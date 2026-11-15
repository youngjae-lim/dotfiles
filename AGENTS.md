# AGENTS.md: dotfiles repo

Instructions for AI agents working **in this repository**. Global, cross-repo agent instructions are generated from `home/.chezmoitemplates/agents.md`.

## What this is
Youngjae's macOS dotfiles, managed by **chezmoi**. The repo lives at `~/Dotfiles` (chezmoi `sourceDir`). It is **public**, so nothing secret may ever be committed.

## Layout
| Path | Purpose |
|---|---|
| `home/` | chezmoi source state (`.chezmoiroot`). `dot_x` → `~/.x`, `private_` → 0600/0700, `executable_` → +x, `*.tmpl` → Go templates, `symlink_*` → symlinks, `modify_*` → scripts that rewrite an existing file. |
| `home/.chezmoidata/agents.yaml` | **Single source** for agent permissions, secret paths and MCP servers (`http` or `stdio`). Rendered into Claude, Copilot, Gemini and VS Code configs, and the Claude secret-guard hook. |
| `home/.chezmoitemplates/agents.md` | Global agent instructions → `~/.claude/CLAUDE.md`, `~/.copilot/copilot-instructions.md`, `~/.gemini/GEMINI.md`. |
| `home/.chezmoitemplates/merge-json.sh` | Body of `modify_*.json` scripts: deep-merges managed keys into app-owned JSON. `owned` keys (e.g. `mcpServers`) are replaced wholesale so removals propagate. |
| `home/dot_claude/hooks/dotfiles/` | Claude Code hooks: `guard-secrets.sh` (PreToolUse, blocks denyPaths) and `notify.sh` (macOS notification when Claude waits on you). Registered in `modify_settings.json.tmpl`, merged so other tools' hooks (herdr) survive. |
| `home/dot_agents/skills/` | Agent skills → `~/.agents/skills` (Copilot + Gemini read it; `~/.claude/skills` symlinks to it). |
| `home/.chezmoiscripts/` | `run_onchange_*` scripts: brew bundle, mise install, herdr integrations + Claude MCP. |
| `config/` | Configs that apps rewrite themselves (nvim, karabiner, VS Code settings/keybindings). `~` symlinks **into** this dir, so in-app edits appear in `git diff`. VS Code's `mcp.json` is the exception: generated from `agents.yaml`. |
| `Brewfile` | All Homebrew packages; applied automatically when it changes. |
| `scripts/` | `check.sh` (validate everything), `check-agents.py` (agent-config parity), `macos-defaults.sh` (manual). |
| `.github/workflows/check.yml` | CI: runs `scripts/check.sh` on every push. |
| `docs/guide.md` | Human learning guide for every tool here. Update it when you change a workflow, keybinding or command it documents. |
| `install.sh` | New-machine bootstrap. |

## Rules
- **Secrets:** never write literal secrets. Use `{{ onepasswordRead "op://Dev/<item>/<field>" }}` in a `private_*.tmpl` file. Do not run `op` yourself; ask the user.
- Edit the **source** in this repo, never the rendered file in `~`. Check with `chezmoi diff`; the user runs `chezmoi apply`.
- Adding a file: `chezmoi add ~/.foo` (or `--template`) rather than creating source names by hand, unless you know the naming rules above.
- Agent permission, secret-path or MCP changes go in `home/.chezmoidata/agents.yaml`, not in per-agent files. Never put secrets in it (no `env` values for MCP servers).
- Keep `home/` macOS-first; guard OS-specific paths in `home/.chezmoiignore`.

## Validate before finishing
```sh
scripts/check.sh                     # parity + shellcheck + stylua + gitleaks; must pass
chezmoi diff                         # what would change in ~
chezmoi execute-template < file.tmpl # render one template
```
`scripts/check.sh` renders every agent config and fails if any disagrees with `agents.yaml`. If you add a new place that renders agent policy, add a check for it to `scripts/check-agents.py`. CI runs the same script.
The pre-commit hook (`.githooks/pre-commit`) runs gitleaks on staged changes. Never bypass it with `--no-verify`.

## Style
- Lua: stylua (`config/nvim/stylua.toml`, `home/dot_hammerspoon/stylua.toml`).
- Shell: bash/zsh, `set -euo pipefail` in scripts, pass shellcheck. Scripts in `~/.local/bin` and hooks run under macOS `/bin/bash` 3.2: no `${x^}`, `mapfile`, or empty arrays under `set -u`.
- Commits: Conventional Commits, scoped by tool, e.g. `feat(zsh): add wt helper`.
