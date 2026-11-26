# dotfiles

My macOS setup, built for working with AI coding agents. Managed with [chezmoi](https://chezmoi.io). The same repo also sets up spare Ubuntu machines with the shell, Neovim and agents ([docs](docs/14-spare-linux.md)).

> **New to these tools?** Start with the [docs](docs/README.md): ten short chapters that explain everything from zero, a [glossary](docs/glossary.md) and a [cheat sheet](docs/cheatsheet.md).

| Layer | Tool |
|---|---|
| Terminal | [Ghostty](https://ghostty.org) |
| Agent runtime / multiplexer | [herdr](https://herdr.dev) (tmux as fallback) |
| Agents | Claude Code, GitHub Copilot CLI, Gemini CLI, Copilot in VS Code |
| Editors | Neovim (lean config on the built-in `vim.pack`, [docs](docs/11-neovim.md)) + VS Code |
| Shell | zsh (vi-mode, hand-rolled prompt and plugin loader) |
| Runtimes | [mise](https://mise.jdx.dev) (node, python, go) + Laravel Herd (PHP) |
| Secrets | 1Password CLI via chezmoi templates |
| Windows / keys | AeroSpace, Karabiner-Elements, Hammerspoon (Korean input indicator) |
| Remote / phone | Tailscale + [Ovis](https://ovis.sh) on top of herdr |

## Install (new Mac)

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/youngjae-lim/dotfiles/main/install.sh)"
```

The script installs Homebrew, chezmoi and 1Password, waits for you to turn on 1Password CLI integration, then runs `chezmoi init --apply`. That installs the Brewfile, mise runtimes, agent integrations and every config. Optional extras:

```sh
~/Dotfiles/scripts/macos-defaults.sh   # Dock/Finder/Spaces defaults
```

**Spare Ubuntu machine:** the same command. On Linux it installs apt packages, Homebrew, 1Password's CLI, Tailscale and the agents, applies the shared part of the dotfiles, and makes zsh the login shell. See [chapter 14](docs/14-spare-linux.md).

## Daily use

```sh
chezmoi diff      # preview changes to ~      (alias: czd)
chezmoi apply     # apply                     (alias: cza)
chezmoi update    # git pull + apply
updater           # fzf menu: brew, mise, agents, herdr, zsh plugins
```

### Agents

- Everything shared is generated from one place:
  - Instructions come from [`home/.chezmoitemplates/agents.md`](home/.chezmoitemplates/agents.md) and are installed as `~/.claude/CLAUDE.md`, `~/.copilot/copilot-instructions.md` and `~/.gemini/GEMINI.md`.
  - Permissions and MCP servers come from [`home/.chezmoidata/agents.yaml`](home/.chezmoidata/agents.yaml), for Claude, Copilot, Gemini and VS Code. The default policy auto-approves file edits and safe local commands, asks before network or destructive actions, and never lets agents read secrets. Claude also gets a secret-guard hook and a macOS notification when it's waiting on you.
  - `scripts/check.sh` (and CI) verifies every agent's rendered config still matches `agents.yaml`.
  - Skills come from [`home/dot_agents/skills/`](home/dot_agents/skills) and are installed to `~/.agents/skills`. Copilot and Gemini read that folder directly; `~/.claude/skills` is a symlink to it.
- `wt <branch> [claude|copilot|gemini]` creates a git worktree and starts an agent in it. Inside herdr, it opens the worktree as a new workspace. `wt ls`, `wt rm <branch>` and `wt prune` (removes merged, clean worktrees) clean up.
- `agents-init` writes an `AGENTS.md` + `CLAUDE.md` for the current repo, with its detected test/lint/format commands.
- `?? <question>` gives a quick answer from Copilot without running any tools.
- To write a long prompt in nvim, press `Esc` then `v` (or Ctrl-X Ctrl-E).
- In Ghostty, Shift+Enter inserts a newline in agent prompts.

### Secrets

Secrets live in the 1Password vault `Dev` and are rendered into `~/.config/zsh/secrets.zsh` (mode 600) at apply time. A gitleaks pre-commit hook blocks accidental commits. To add a secret:

```sh
op item create --vault Dev --category "API Credential" --title MY_TOKEN credential=...
# then add a line to home/dot_config/zsh/private_secrets.zsh.tmpl:
# export MY_TOKEN={{ onepasswordRead "op://Dev/MY_TOKEN/credential" | squote }}
```

## Layout

See [AGENTS.md](AGENTS.md).
