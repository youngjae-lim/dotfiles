# Cheat sheet

[← Back to start](README.md) · Words you don't know: [glossary](glossary.md)

Keep this open while you learn. Each block links to the chapter that explains it.

## Every day

```
HERDR  (Ctrl+B, let go, then…)           CLAUDE CODE
  q detach     ? help      v / - split     Esc stop       Esc Esc rewind
  h j k l move z zoom      x close pane    Shift+Tab mode @file mention
  c new tab    n / p tabs  w workspaces    !cmd shell     /clear /compact
  Shift+N new workspace    Alt+G lazygit   /skills /mcp /permissions /hooks

AEROSPACE (Alt = Option)                 SHELL
  Alt+H/J/K/L focus   +Shift move        wt <branch> [agent]   tt   ?? <question>
  Alt+<letter> go     +Shift send there  wt ls · wt rm <b> · wt prune · agents-init
  Alt+Tab back   Alt+/ tiles  Alt+, stack Esc v  edit command in nvim
  Alt+Enter new Ghostty  Alt+Shift+= even  updater   notes --help   dot
  Alt+Shift+Enter full screen (never the green button)

WORKSPACES   32": T terminal · C code · D data
             27": B browser · W work · R reading · M messages
             either: Z zoom · N notes · 1-9 scratch
```

Chapters: [herdr](04-terminal.md#herdr-where-your-agents-live) · [Claude Code](05-ai-agents.md#keys-and-commands-worth-knowing) · [AeroSpace](09-desktop.md#aerospace-window-tiling) · [shell](08-languages-and-tools.md#your-shell-shortcuts) · [wt](06-worktrees.md)

## Changing your config

```
CHEZMOI                                  SECRETS
  czd  diff (preview, changes nothing)     op read "op://Dev/<item>/credential"
  cza  apply (make ~ match the repo)       add a line to private_secrets.zsh.tmpl
  cze <file>  edit source + apply on save  leading space = not saved in history
  chezmoi status  (empty = in sync)
  chezmoi re-add  keep an edit made in ~

APPLY OR NOT?   (apply = use it on this Mac · commit = save it in git; separate)
  config/nvim, config/vscode, config/karabiner → live links, NO apply
  agents.yaml                                  → scripts/check.sh, then apply
  anything else in home/, plus Brewfile        → chezmoi apply, then reload the app
  docs/, README, AGENTS.md, scripts/           → NO apply, just commit

BEFORE COMMITTING
  scripts/check.sh   agent settings, shellcheck, stylua, gitleaks
```

Chapters: [chezmoi](02-chezmoi-basics.md) · [special files](03-how-files-are-made.md) · [secrets](07-secrets.md)

## Where things live (`~/Dotfiles`)

```
home/.chezmoitemplates/agents.md   instructions for all agents
home/.chezmoidata/agents.yaml      permissions, secret paths, MCP servers (all agents)
home/dot_agents/skills/            skills (all agents)
home/dot_config/zsh/               shell
home/dot_config/<app>/             most app configs (Ghostty, herdr, AeroSpace, mise…)
config/nvim, config/vscode         editors (live links)
Brewfile                           apps (installed automatically when it changes)
scripts/check.sh                   run before every commit
```
