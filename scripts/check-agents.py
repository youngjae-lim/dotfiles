#!/usr/bin/env python3
"""Check that every agent's rendered config agrees with agents.yaml.

Renders the templates with `chezmoi execute-template` (nothing in ~ is
touched), runs the modify_ scripts against fake existing files, and checks
the results. Exits non-zero on any mismatch.

Usage: scripts/check-agents.py         (CHEZMOI=/path/to/chezmoi to override)
Needs: chezmoi, jq, python >= 3.11.
"""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tomllib
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
HOME_SRC = REPO / "home"
CHEZMOI = os.environ.get("CHEZMOI", "chezmoi")
VSCODE_MCP = "private_Library/private_Application Support/private_Code/User/modify_mcp.json.tmpl"

failures: list[str] = []


def check(ok: bool, what: str, detail: str = "") -> None:
    print(f"{'ok  ' if ok else 'FAIL'} {what}")
    if not ok:
        failures.append(what)
        if detail:
            print(f"     {detail}")


def render(template: str) -> str:
    return subprocess.run(
        [CHEZMOI, "--source", str(REPO), "execute-template"],
        input=template, capture_output=True, text=True, check=True,
    ).stdout


def render_file(rel: str) -> str:
    return render((HOME_SRC / rel).read_text())


def run_modify(rel: str, current: dict) -> dict:
    """Render a modify_ template and run it on `current`, like chezmoi apply."""
    script = render_file(rel)
    out = subprocess.run(["sh", "-c", script], input=json.dumps(current),
                         capture_output=True, text=True, check=True).stdout
    return json.loads(out)


def sample_paths(glob: str, home: str) -> list[str]:
    """Concrete paths a denyPaths glob must block."""
    if glob.startswith("**/"):
        name = glob[3:].replace("*", "development")
        return [f"{home}/proj/{name}", name]
    if glob.endswith("/**"):
        return [glob[:-3].replace("~", home, 1) + "/id_ed25519"]
    return [glob.replace("~", home, 1)]


def main() -> int:
    agents = json.loads(render("{{ .agents | toJson }}"))
    home = render("{{ .chezmoi.homeDir }}").strip()
    allow, ask, deny_cmds = agents["allowCommands"], agents["askCommands"], agents["denyCommands"]
    deny_paths, mcp = agents["denyPaths"], agents["mcpServers"]
    copilot = agents.get("copilot", {})

    # --- Claude Code settings.json --------------------------------------
    print("# Claude Code")
    claude = run_modify("dot_claude/modify_settings.json.tmpl",
                        {"appState": 1, "permissions": {"allow": ["Bash(stale:*)"]}})
    perms = claude.get("permissions", {})
    check(claude.get("appState") == 1, "settings.json keeps keys the app wrote")
    want_allow = {f"Bash({c}:*)" for c in allow}
    check(want_allow <= set(perms.get("allow", [])), "every allowCommand is allowed",
          str(sorted(want_allow - set(perms.get("allow", [])))))
    check("Bash(stale:*)" not in perms.get("allow", []), "stale allow rules are replaced")
    check({f"Bash({c}:*)" for c in ask} <= set(perms.get("ask", [])), "every askCommand asks")
    want_deny = {f"Bash({c}:*)" for c in deny_cmds}
    want_deny |= {f"{t}({p})" for p in deny_paths for t in ("Read", "Edit")}
    check(want_deny <= set(perms.get("deny", [])), "every denyCommand/denyPath is denied",
          str(sorted(want_deny - set(perms.get("deny", [])))))

    # --- Gemini CLI policy ------------------------------------------------
    print("# Gemini CLI")
    rules = tomllib.loads(render_file("dot_gemini/policies/dotfiles.toml.tmpl"))["rule"]
    by = lambda d: [r for r in rules if r["decision"] == d]  # noqa: E731
    check(sorted(sum((r.get("commandPrefix", []) for r in by("allow")), [])) == sorted(allow),
          "allow rule matches allowCommands")
    check(sorted(sum((r.get("commandPrefix", []) for r in by("ask_user")), [])) == sorted(ask),
          "ask rule matches askCommands")
    regexes = [re.compile(r["commandRegex"]) for r in by("deny") if "commandRegex" in r]
    for c in deny_cmds:
        check(any(rx.search(f'{{"command":"{c} x"}}') for rx in regexes), f"denies command: {c}")
    file_rules = [r for r in by("deny") if "argsPattern" in r]
    for tool in ("read_file", "read_many_files", "write_file", "replace"):
        pats = [re.compile(r["argsPattern"]) for r in file_rules if r["toolName"] == tool]
        for glob in deny_paths:
            for path in sample_paths(glob, home):
                args = json.dumps({"file_path": path})
                check(any(p.search(args) for p in pats), f"{tool} blocks {path}")
        harmless = json.dumps({"file_path": f"{home}/proj/.env.example"})
        check(not any(p.search(harmless) for p in pats), f"{tool} still allows .env.example")

    # --- Copilot CLI wrapper ---------------------------------------------
    print("# Copilot CLI")
    wrapper = render_file("dot_config/zsh/agents.zsh.tmpl")
    c_allow = re.findall(r"--allow-tool='([^']*)'", wrapper)
    c_deny = set(re.findall(r"--deny-tool='([^']*)'", wrapper))
    check(c_allow == copilot.get("allowTools", []), "allow flags match copilot.allowTools")
    shared = set(allow) | {a.removeprefix("./") for a in allow}
    broader = [t for t in c_allow
               if t.startswith("shell(") and t[6:-1].removeprefix("./") not in shared]
    check(not broader, "Copilot allows no command the shared allowCommands don't", str(broader))
    want = {f"shell({c})" for c in deny_cmds if " " not in c}
    want |= {f"{t}({p.removeprefix('**/')})" for p in deny_paths for t in ("read", "write")}
    check(want <= c_deny, "deny flags cover denyCommands and denyPaths", str(sorted(want - c_deny)))

    # --- MCP servers, all four agents -------------------------------------
    print("# MCP servers")
    stale = {"stale-server": {"type": "http", "url": "https://example.invalid"}}

    def same(name: str, got: dict, url_key: str = "url") -> bool:
        s = mcp[name]
        if s["type"] == "http":
            return got.get(url_key) == s["url"]
        return got.get("command") == s["command"] and got.get("args", []) == s.get("args", [])

    for label, rel, key, url_key in (
        ("Copilot", "private_dot_copilot/modify_mcp-config.json.tmpl", "mcpServers", "url"),
        ("Gemini", "dot_gemini/modify_settings.json.tmpl", "mcpServers", "httpUrl"),
        ("VS Code", VSCODE_MCP, "servers", "url"),
    ):
        out = run_modify(rel, {key: stale, "appState": 1})
        servers = out.get(key, {})
        check(set(servers) == set(mcp), f"{label}: exactly the agents.yaml servers",
              f"got {sorted(servers)}, want {sorted(mcp)}")
        check(out.get("appState") == 1, f"{label}: keeps keys the app wrote")
        for name in mcp:
            check(name in servers and same(name, servers[name], url_key), f"{label}: {name} is correct")

    script = render_file(".chezmoiscripts/run_onchange_after_30-agent-integrations.sh.tmpl")
    added = dict(re.findall(r"claude mcp add-json --scope user '([^']+)' '(\{.*\})'", script))
    check(set(added) == set(mcp), "Claude: adds exactly the agents.yaml servers", str(sorted(added)))
    for name, cfg in added.items():
        if name in mcp:
            got = json.loads(cfg)
            check(got.get("type") == mcp[name]["type"] and same(name, got), f"Claude: {name} is correct")
    managed = re.search(r"managed=\(([^)]*)\)", script)
    check(bool(managed) and set(re.findall(r"'([^']+)'", managed.group(1))) == set(mcp),
          "Claude: prune list matches agents.yaml")

    # --- Shared instructions ----------------------------------------------
    print("# Instructions")
    base = render('{{ template "agents.md" . }}').strip()
    for rel in ("dot_claude/CLAUDE.md.tmpl", "private_dot_copilot/copilot-instructions.md.tmpl",
                "dot_gemini/GEMINI.md.tmpl"):
        check(render_file(rel).strip() == base, f"{rel} renders agents.md")

    hooks_check(claude, deny_paths, home)

    print()
    if failures:
        print(f"{len(failures)} check(s) failed.")
        return 1
    print("All agent configs agree with agents.yaml.")
    return 0


def hooks_check(claude: dict, deny_paths: list[str], home: str) -> None:
    """Claude hooks: registered in settings.json, and the guard blocks secrets."""
    guard_src = HOME_SRC / "dot_claude/hooks/dotfiles/executable_guard-secrets.sh.tmpl"
    if not guard_src.exists():
        return
    print("# Claude hooks")
    hooks = claude.get("hooks", {})
    cmds = [h.get("command", "") for e in hooks.values() for m in e for h in m.get("hooks", [])]
    for name in ("guard-secrets.sh", "notify.sh"):
        check(any(c.endswith(f"/.claude/hooks/dotfiles/{name}") for c in cmds), f"settings.json runs {name}")

    merged = run_modify("dot_claude/modify_settings.json.tmpl", {"hooks": {"PreToolUse": [
        {"matcher": "Bash", "hooks": [{"type": "command", "command": "herdr hook"}]},
        {"matcher": "Bash", "hooks": [{"type": "command",
                                       "command": f"{home}/.claude/hooks/dotfiles/old.sh"}]}]}})
    pre = [h["command"] for m in merged["hooks"].get("PreToolUse", []) for h in m["hooks"]]
    check("herdr hook" in pre, "hooks from other tools (herdr) are kept")
    check(not any(c.endswith("/old.sh") for c in pre), "removed dotfiles hooks are pruned")
    check(len(pre) == len(set(pre)), "re-applying does not duplicate hooks")

    script = render(guard_src.read_text())

    def blocked(tool: str, tool_input: dict) -> bool:
        event = json.dumps({"tool_name": tool, "tool_input": tool_input})
        return subprocess.run(["bash", "-c", script], input=event,
                              capture_output=True, text=True).returncode == 2

    for glob in deny_paths:
        for path in sample_paths(glob, home):
            check(blocked("Read", {"file_path": path}), f"guard blocks Read {path}")
            check(blocked("Bash", {"command": f"cat {path} | head"}), f"guard blocks Bash cat {path}")
    for tool, tool_input in (
        ("Read", {"file_path": f"{home}/proj/.env.example"}),
        ("Bash", {"command": "git status"}),
        ("Edit", {"file_path": f"{home}/proj/README.md", "old_string": "a", "new_string": "never read .env"}),
    ):
        check(not blocked(tool, tool_input), f"guard allows {tool} {json.dumps(tool_input)[:60]}")


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as e:
        print(f"FAIL {' '.join(map(str, e.cmd))[:120]}\n{e.stderr}", file=sys.stderr)
        sys.exit(1)
