# Glossary

[← Back to start](README.md)

Every term these docs use, in plain words, alphabetically. The chapter in brackets is where it's explained in context.

### Agent (AI coding agent)
An AI you talk to in the terminal that can also *act*: read and edit files and run commands, such as your tests. Here: Claude Code, Copilot CLI and Gemini CLI. ([Chapter 5](05-ai-agents.md))

### `AGENTS.md`
A file at the root of a project with instructions for AI agents working in it: how to run its tests, rules to follow. All three agents read it. `agents-init` writes a first version for you. ([Chapter 5](05-ai-agents.md#project-level-instructions-agentsmd))

### `agents.yaml`
The one file (`home/.chezmoidata/agents.yaml`) that holds the rules for every AI agent: which commands they may run, which files are secret, and which MCP servers they get. chezmoi turns it into each agent's own settings. ([Chapter 5](05-ai-agents.md))

### Alias
A short name for a longer command. `czd` is an alias for `chezmoi diff`. Yours are in `home/dot_config/zsh/aliases.zsh`. ([Chapter 2](02-chezmoi-basics.md))

### Allow / ask / deny
The three buckets an agent's commands fall into: run without asking, always ask you first, or never allowed. ([Chapter 5](05-ai-agents.md#what-agents-may-do))

### Apply (`chezmoi apply`)
Make your home folder match the repo: copy, generate and link the files that differ. ([Chapter 2](02-chezmoi-basics.md))

### Branch
A separate line of work in a git repo. You make changes on a branch, then merge it into `main`. ([Chapter 6](06-worktrees.md))

### Brewfile
A list of every app and tool to install with Homebrew. When it changes, `chezmoi apply` installs what's new. ([Chapter 3](03-how-files-are-made.md#scripts-that-run-on-apply))

### Bundle ID
The unique name macOS gives each app, like `com.google.Chrome`. AeroSpace rules use it to recognise apps; `aerospace list-apps` shows them. ([Chapter 9](09-desktop.md#your-workspaces-one-letter-per-job))

### Checkout
The files you see in a project folder: one branch's version of the repo. ([Chapter 6](06-worktrees.md))

### chezmoi
The dotfiles manager. It reads `~/Dotfiles` (the source) and writes your home folder (the target). ([Chapter 2](02-chezmoi-basics.md))

### CI (continuous integration)
Checks that run automatically on GitHub every time you push. This repo's CI runs `scripts/check.sh` (the file is `.github/workflows/check.yml`; [what it checks](02-chezmoi-basics.md#what-scriptschecksh-checks)). **GitHub Actions** is GitHub's name for this service.

### CLI (command-line interface)
A program you use by typing in the terminal, not by clicking. ([Chapter 5](05-ai-agents.md))

### Commit
A saved snapshot of the repo with a message describing the change. **Conventional Commits** is the message style used here: `feat(zsh): add an alias`. ([Chapter 2](02-chezmoi-basics.md))

### Context (of an agent)
Everything the agent currently has in mind: your messages, files it read, command output. It has a size limit; `/clear` and `/compact` free it up. ([Chapter 5](05-ai-agents.md))

### Detach
Leave herdr without stopping anything; everything keeps running in the background. `Ctrl+B` then `q`. ([Chapter 4](04-terminal.md))

### Diff (`chezmoi diff`, `git diff`)
A listing of the differences between two versions. `-` lines would be removed, `+` lines added. `chezmoi diff` shows what `apply` would change; `git diff` shows what you haven't committed. ([Chapter 2](02-chezmoi-basics.md))

### Dotfiles
Settings files for command-line tools, named with a leading dot (`.zshrc`), which hides them. Also: the repo that holds them. ([Start here](README.md))

### Environment variable
A named value every program can read, like `EDITOR=nvim`. Set in `home/dot_config/zsh/env.zsh`. ([Chapter 4](04-terminal.md#zsh-your-shell))

### Generated file
A file chezmoi builds from another source file, such as the four agents' settings from `agents.yaml`. Edit the source, never the output. ([Chapter 3](03-how-files-are-made.md#generated-files))

### git
The tool that tracks a folder's history: every change, who made it and why. `~/Dotfiles` is a git repo.

### gitleaks
A scanner that looks for secrets. It runs before every commit in this repo and blocks the commit if it finds one. ([Chapter 7](07-secrets.md#the-safety-net-gitleaks))

### Home folder (`~`)
Your personal folder, `/Users/youngjaelim`. `~/.zshrc` means "`.zshrc` in my home folder".

### Homebrew (`brew`)
The usual way to install software on a Mac from the terminal. A **cask** is a Homebrew package that's a full app (Ghostty, Firefox) rather than a command-line tool.

### Hook
A small script that runs automatically at a fixed moment. Claude's hooks here run before every tool call (the secret guard) and when Claude needs you (the notification). Git also has hooks: the **pre-commit hook** runs gitleaks before each commit. ([Chapter 5](05-ai-agents.md#how-secrets-are-protected-three-layers))

### jq
A command-line tool for reading and changing JSON. The `modify_` scripts use it to merge settings. ([Chapter 3](03-how-files-are-made.md#merged-files-modify_))

### JSON
A text format for settings and data, built from `{"name": "value"}`. Most apps' settings files use it.

### Lane
This guide's name for the three ways a file reaches your home folder: copied, linked or generated. ([Chapter 1](01-big-picture.md#three-ways-a-file-gets-to-your-mac))

### Linter, formatter
A **linter** points out likely mistakes in code (shellcheck for shell scripts). A **formatter** rewrites code into a consistent style (stylua for Lua).

### MCP (Model Context Protocol), MCP server
A standard way to plug extra tools into an AI agent. An **MCP server** is one such tool: either a web address (`type: http`) or a small program the agent starts on your Mac (`type: stdio`). Yours: `context7` and `time`. ([Chapter 5](05-ai-agents.md#adding-an-mcp-server))

### Merge
Combining one branch's changes into another, usually a feature branch into `main`. A **squash merge** combines all the branch's commits into one new commit first; afterwards `git branch -d` doesn't recognise the branch as merged, so delete it with `-D`. ([Chapter 2](02-chezmoi-basics.md#the-routine-start-to-finish))

### Merge conflict
Two branches changed the same lines, so git can't combine them on its own. Git marks the clash with `<<<<<<<`, `=======` and `>>>>>>>`; you edit the file to keep what you want. ([Chapter 2](02-chezmoi-basics.md#when-a-pull-request-cant-be-merged))

### Mermaid
A way of writing diagrams as text, which GitHub draws as pictures. The diagrams in these docs are Mermaid.

### mise
The tool that installs and switches versions of node, python and go. ([Chapter 8](08-languages-and-tools.md))

### `modify_` file
A chezmoi file that updates *part* of a settings file an app also writes to, instead of replacing the whole thing. ([Chapter 3](03-how-files-are-made.md#merged-files-modify_))

### Multiplexer (terminal multiplexer)
A program that holds many terminals in one window and keeps them running in the background. herdr is yours; tmux is the fallback. ([Chapter 4](04-terminal.md))

### Pane, tab, workspace, session (herdr)
A **pane** is one terminal. A **tab** is a layout of panes. A **workspace** is one project's set of tabs. The **session** is the background server holding them all. ([Chapter 4](04-terminal.md#words-you-need))

### PATH
The list of folders the shell searches when you type a command. If the wrong version of something runs, PATH is usually why. ([Chapter 4](04-terminal.md#zsh-your-shell))

### Prefix key
A key you press first, then let go, before a shortcut. herdr's is `Ctrl+B`; tmux's is `Ctrl+F`. ([Chapter 4](04-terminal.md))

### Pull (`git pull`)
Fetch the latest commits from GitHub and add them to the branch you're on. The opposite direction of a push.

### Pull request (PR)
A request on GitHub to merge a branch, where the changes can be reviewed (and CI runs) first.

### Push
Send your commits to GitHub.

### Repository (repo)
A folder whose history git tracks. `~/Dotfiles` is one; so is each project in `~/Projects`.

### Runtime
The program that runs code in a language: `node`, `python`, `go`. ([Chapter 8](08-languages-and-tools.md))

### Secret
Anything that grants access: a password, an API key, a token. Secrets live in 1Password, never in this repo. ([Chapter 7](07-secrets.md))

### Shell
The program that reads and runs what you type in a terminal. Yours is **zsh**. ([Chapter 4](04-terminal.md))

### Skill
A short instruction file an agent reads only when the task matches, like a recipe card: `commit`, `code-review`, `go-conventions`… ([Chapter 5](05-ai-agents.md))

### Source, target (chezmoi)
The **source** is what's in `~/Dotfiles`; the **target** is your home folder, where chezmoi writes. ([Chapter 2](02-chezmoi-basics.md))

### Space (macOS), Desktop
macOS's own virtual desktops, shown along the top of Mission Control. A window in native full screen gets a Space of its own. With AeroSpace, keep exactly one per monitor: AeroSpace's workspaces replace them. ([Chapter 9](09-desktop.md))

### Switch (`git switch`)
Change which branch your folder shows. `git switch -c <name>` creates a new branch and switches to it. chezmoi applies whichever branch you've switched to. ([Chapter 2](02-chezmoi-basics.md#the-one-rule-your-mac-follows-the-branch-youre-on))

### Symlink (symbolic link)
A file that points at another file, like a shortcut. `~/.config/nvim` is a symlink to `~/Dotfiles/config/nvim`, so there's only one real copy. ([Chapter 1](01-big-picture.md#three-ways-a-file-gets-to-your-mac))

### Template
A file with blanks (`{{ … }}`) that chezmoi fills in when it applies. Names end in `.tmpl`. ([Chapter 3](03-how-files-are-made.md#templates))

### Terminal (terminal emulator)
The app that shows the text window you type commands into. Yours is **Ghostty**. ([Chapter 4](04-terminal.md))

### Tiling window manager
A program that arranges windows side by side automatically. Yours is **AeroSpace**. ([Chapter 9](09-desktop.md))

### TOML
Another settings-file format, made of `name = value` lines and `[sections]`. Ghostty, AeroSpace and mise use it.

### Vault (1Password)
A folder of items in 1Password. Your terminal secrets are in the vault named **Dev**. ([Chapter 7](07-secrets.md))

### Worktree
A second checkout of the same repo, in another folder, on another branch. Lets several agents work at once without clashing. ([Chapter 6](06-worktrees.md))

### YAML
A settings-file format built from `name: value` lines and indented `- item` lists. `agents.yaml` is YAML.
