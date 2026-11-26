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

AEROSPACE (M2; Alt = Option = right Cmd) SHELL
  Alt+H/J/K/L focus   +Shift move        wt <branch> [agent]   tt   ?? <question>
  Alt+<letter> go     +Shift send there  wt ls · wt rm <b> · wt prune · agents-init
  Alt+Tab back   Alt+/ tiles  Alt+, stack Esc v  edit command in nvim
  Alt+Enter new Ghostty  Alt+Shift+= even  updater   notes --help   dot
  Alt+Shift+Enter full screen (never the green button)
  Alt+Shift+; then f  float ↔ tile    then r  reset layout
  Alt+Shift+H/J/K/L  swap with neighbour   red outline = focused window

WORKSPACES   T terminal · C code · D data · B browser · W work (Chrome + Teams) · R reading
             M messages · Z zoom · N notes · 1-9 scratch
             any monitor; Alt+Shift+Tab moves a workspace to the other one

KEYBOARD (Karabiner, on the M2)
  Caps Lock   tap = Esc, hold = Ctrl       Right Cmd = Option (Alt)
  Ctrl+H/J/K/L = arrow keys, everywhere    Left Cmd unchanged
  Caps+Tab / Caps+Shift+Tab = next / previous tab (Chrome, most apps)

NEOVIM   (Space = leader; press it and wait for the key-hint popup)
  Space Space  find files     Space /  search text   Space e  file tree
  Space fr     recent files   Space fb buffers       Space cs outline
  Tab / S-Tab  next/prev buf  Space bd close buffer  Space mx zoom window
  gd  definition   grr references   K hover docs     Space cr rename
  Space ca  code action      ]d [d  next/prev problem Space cd line problems
  Space cf  format           ys ds cs  surround      ]h [h  git changes
  Space gg  lazygit          Space uC  theme         Space qs restore session
  Space nf / ng  find / search notes   Space nr / np  note → PDF / slides
  Space nh  note history             Space nc  save notes to GitHub
  ;t (typing) / Space nt  add a time stamp to a note
  Space tt / Ctrl+/  terminal show/hide (Ctrl+/ works inside it; Esc Esc = normal keys)
  Arrows move between windows (Shift+arrows resize)  ;a ;e  line start/end
  Typing: Enter accept menu · Tab accept Copilot · Ctrl+G next suggestion
```

Chapters: [herdr](04-terminal.md#herdr-where-your-agents-live) · [Claude Code](05-ai-agents.md#keys-and-commands-worth-knowing) · [AeroSpace](09-desktop.md#aerospace-window-tiling) · [keyboard](09-desktop.md#karabiner-and-hammerspoon) · [shell](08-languages-and-tools.md#your-shell-shortcuts) · [wt](06-worktrees.md) · [Neovim](11-neovim.md#keys-youll-use)

## Changing your config

```
CHEZMOI                                  SECRETS
  czd  diff (preview, changes nothing)     op read "op://Dev/<item>/credential"
  cza  apply (make ~ match the repo)       add a line to private_secrets.zsh.tmpl
  cze <file>  edit source + apply on save  leading space = not saved in history
  chezmoi status  (empty = in sync)
  chezmoi re-add  keep an edit made in ~

APPLY OR NOT?   (apply = use it on this computer · commit = save it in git; separate)
  config/nvim, config/vscode, config/karabiner → live links, NO apply
  agents.yaml                                  → scripts/check.sh, then apply
  anything else in home/, plus Brewfile        → chezmoi apply, then reload the app
  docs/, README, AGENTS.md, scripts/           → NO apply, just commit

BEFORE COMMITTING
  scripts/check.sh   agent settings, shellcheck, stylua, gitleaks
```

## Backup and the spares

```
DRIVE BACKUP  (the M2, drive plugged in)    UBUNTU SPARES  (Mac Pro, Mac mini)
  drive-backup --dry-run | tail -20           chezmoi update   pull + apply
  drive-backup        back up what changed    updater          same menu as the M2
  drive-backup check  every few months        drive-backup ls · restore "<path>"
  drive-backup ls · restore "<path>"          notes sync first, notes save last
```

Chapters: [drive backup](13-drive-backup.md) · [spares](14-spare-linux.md)

Chapters: [chezmoi](02-chezmoi-basics.md) · [special files](03-how-files-are-made.md) · [secrets](07-secrets.md)

## Where things live (`~/Dotfiles`)

```
home/.chezmoitemplates/agents.md   instructions for all agents
home/.chezmoidata/agents.yaml      permissions, secret paths, MCP servers (all agents)
home/dot_agents/skills/            skills (all agents)
home/dot_config/zsh/               shell
home/dot_config/<app>/             most app configs (Ghostty, herdr, AeroSpace, mise…)
config/nvim, config/vscode         editors (live links)
Brewfile                           apps (installed when it changes; Mac-only ones inside if OS.mac?)
scripts/check.sh                   run before every commit
```
