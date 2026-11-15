# AGENTS.md: dotfiles repo

Instructions for AI agents working **in this repository**. Global, cross-repo agent instructions are generated from `home/.chezmoitemplates/agents.md`.

## What this is
Youngjae's macOS dotfiles, managed by **chezmoi**. The repo lives at `~/Dotfiles` (chezmoi `sourceDir`). It is **public**, so nothing secret may ever be committed.

## Layout
| Path | Purpose |
|---|---|
| `home/` | chezmoi source state (`.chezmoiroot`). `dot_x` → `~/.x`, `private_` → 0600/0700, `executable_` → +x, `*.tmpl` → Go templates, `symlink_*` → symlinks, `modify_*` → scripts that rewrite an existing file. |
| `home/.chezmoidata/agents.yaml` | **Single source** for agent permissions + MCP servers. Rendered into Claude, Copilot, Gemini configs. |
| `home/.chezmoitemplates/agents.md` | Global agent instructions → `~/.claude/CLAUDE.md`, `~/.copilot/copilot-instructions.md`, `~/.gemini/GEMINI.md`. |
| `home/.chezmoitemplates/merge-json.sh` | Body of `modify_*.json` scripts: deep-merges managed keys into app-owned JSON. |
| `home/dot_agents/skills/` | Agent skills → `~/.agents/skills` (Copilot + Gemini read it; `~/.claude/skills` symlinks to it). |
| `home/.chezmoiscripts/` | `run_onchange_*` scripts: brew bundle, mise install, herdr integrations + Claude MCP. |
| `config/` | Configs that apps rewrite themselves (nvim, karabiner, VS Code). `~` symlinks **into** this dir, so in-app edits appear in `git diff`. |
| `Brewfile` | All Homebrew packages; applied automatically when it changes. |
| `scripts/` | Manual one-off scripts (macOS defaults). |
| `docs/guide.md` | Human learning guide for every tool here. Update it when you change a workflow, keybinding or command it documents. |
| `install.sh` | New-machine bootstrap. |

## Rules
- **Secrets:** never write literal secrets. Use `{{ onepasswordRead "op://Dev/<item>/<field>" }}` in a `private_*.tmpl` file. Do not run `op` yourself; ask the user.
- Edit the **source** in this repo, never the rendered file in `~`. Check with `chezmoi diff`; the user runs `chezmoi apply`.
- Adding a file: `chezmoi add ~/.foo` (or `--template`) rather than creating source names by hand, unless you know the naming rules above.
- Agent permission or MCP changes go in `home/.chezmoidata/agents.yaml`, not in per-agent files.
- Keep `home/` macOS-first; guard OS-specific paths in `home/.chezmoiignore`.

## Validate before finishing
```sh
chezmoi diff                         # what would change in ~
chezmoi execute-template < file.tmpl # render one template
shellcheck home/private_dot_local/bin/executable_* scripts/*.sh install.sh
stylua --check config/nvim home/dot_hammerspoon
gitleaks git --no-banner             # must report no leaks
```
The pre-commit hook (`.githooks/pre-commit`) runs gitleaks on staged changes. Never bypass it with `--no-verify`.

## Style
- Lua: stylua (`config/nvim/stylua.toml`, `home/dot_hammerspoon/stylua.toml`).
- Shell: bash/zsh, `set -euo pipefail` in scripts, pass shellcheck.
- Commits: Conventional Commits, scoped by tool, e.g. `feat(zsh): add wt helper`.
