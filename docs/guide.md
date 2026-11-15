# Learning guide: your agent-first Mac setup

This guide teaches the tools in this repo **in the order you'll need them**. It assumes you know Neovim and VS Code and nothing else. Don't try to learn everything at once. Follow the four-week plan in §12 and come back to the chapters as reference.

Each chapter has the same parts:

- **What it is**: one paragraph, no jargon.
- **Why you have it**: the problem it solves for you.
- **The 20% you'll use daily**: the only commands worth memorizing.
- **Try it**: a 5–15 minute exercise. Do it once and it sticks.
- **When it breaks**: the fixes you'll actually need.

---

## 0. The big picture

```
┌──────────────────────────── Ghostty (the window) ─────────────────────────────┐
│ ┌──────────── herdr (keeps sessions alive, shows agent status) ─────────────┐ │
│ │ sidebar        │ pane 1: claude     │ pane 2: copilot   │ pane 3: shell   │ │
│ │ ● genai  done  │ (working…)         │ (blocked: needs   │ $ go test ./... │ │
│ │ ● blog   idle  │                    │  your approval)   │                 │ │
│ └───────────────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────────────────┘
        ▲                         ▲                              ▲
   AeroSpace tiles           agents read shared               zsh + mise give
   this window with          instructions, skills,            every pane the right
   your other apps           permissions (from chezmoi)       node/python/go/php

Phone ── Tailscale (private network) ── Ovis ── herdr   (approve agents from anywhere)
Secrets: 1Password ──(chezmoi apply)──▶ ~/.config/zsh/secrets.zsh  (never in git)
```

Here's the same picture in words:

1. **Ghostty** is the terminal app. It's only a window; it doesn't do much else.
2. **herdr** runs inside Ghostty. It's like tabs and splits that **keep running when you close the window**, and it knows when an AI agent is busy, done, or waiting for you.
3. **Agents** run in herdr panes: Claude Code, Copilot CLI and Gemini CLI. All three read the **same** instructions, skills and safety rules.
4. **chezmoi** manages all of these config files from the `~/Dotfiles` repo.
5. **mise** makes sure the right versions of node, python and go are on your PATH. PHP still comes from Herd.
6. **1Password** holds your secrets. chezmoi copies them into a private file at apply time, so they never land in git.
7. **AeroSpace** arranges your app windows automatically (tiling).
8. **Tailscale + Ovis** let your phone see and answer your agents.

> **Rule of thumb:** to change a config, edit it in `~/Dotfiles`, run `chezmoi diff`, then `chezmoi apply`. Never edit `~/.zshrc` and friends directly, because the next apply overwrites them.

---

## 1. Ghostty: the terminal

**What it is.** A fast, native macOS terminal. It replaced WezTerm.

**Why you have it.** It's fast and simple, and it supports the newer terminal features agents use: notifications, images, and Shift+Enter for new lines in prompts. Splits and tabs are herdr's job, so Ghostty's config stays tiny. If you switch to Rex later, very little is lost.

**The 20% you'll use daily**

| Action | Keys |
|---|---|
| New window / tab | `Cmd+N` / `Cmd+T` |
| Close | `Cmd+W` |
| Reload config | `Cmd+Shift+,` |
| New line in an agent prompt (instead of sending) | `Shift+Enter` |
| Copy | Just select with the mouse (`copy-on-select` is on) |
| Paste | `Cmd+V` |

**Config:** `~/Dotfiles/home/dot_config/ghostty/config`. Edit it there, run `chezmoi apply`, then press `Cmd+Shift+,` in Ghostty.

**Try it.** Open Ghostty and run `claude`. Type a line, press `Shift+Enter`, type a second line, then press `Enter`. You just sent a two-line prompt.

**When it breaks**
- Fonts look wrong: the config uses `JetBrainsMono NFM`. Run `/Applications/Ghostty.app/Contents/MacOS/ghostty +list-fonts | grep JetBrains` to check it's installed.
- Validate the config: `/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config`.

---

## 2. herdr: where your agents live

**What it is.** A *terminal multiplexer*: one window holding many terminals (panes), organized into **workspaces** (one per project) and **tabs**. A background **server** owns those terminals, so they keep running after you close Ghostty or lose an SSH connection. Unlike tmux, herdr understands AI agents and marks each one **working**, **blocked** (waiting for you), **done** or **idle**.

**Why you have it.** With 2–3 agents working in parallel, you need to see at a glance which one needs you. Closing a window by accident shouldn't kill a 20-minute agent run. Your phone (Ovis) also connects through herdr.

### Words you need

| Word | Meaning |
|---|---|
| **Session** | The background server. You usually have one. `herdr` attaches to it. |
| **Workspace** | One per project (the sidebar list). |
| **Tab** | A layout inside a workspace (e.g. "agents", "server logs"). |
| **Pane** | One real terminal. |
| **Prefix** | `Ctrl+B`. Press it, **let go**, then press the action key. |

### The 20% you'll use daily

| Action | Keys / command |
|---|---|
| Start or re-attach | `herdr` (from a normal Ghostty tab) |
| **Detach** (everything keeps running) | `Ctrl+B` then `q` |
| Show every key binding | `Ctrl+B` then `?` |
| Split right / split down | `Ctrl+B` then `v` / `Ctrl+B` then `-` |
| Move between panes | `Ctrl+B` then `h` `j` `k` `l`, or **click** |
| Zoom a pane full-size (toggle) | `Ctrl+B` then `z` |
| Close pane | `Ctrl+B` then `x` |
| New tab / next / previous | `Ctrl+B` then `c` / `n` / `p` |
| New workspace | `Ctrl+B` then `Shift+N`, or click **new** in the sidebar |
| Pick a workspace | `Ctrl+B` then `w` |
| New git worktree workspace | `Ctrl+B` then `Shift+G` (or `wt`, see §4) |
| Lazygit popup | `Ctrl+B` then `Alt+G` |
| Open a project as a workspace | `tt` (your fzf picker) |
| Stop everything for real | `herdr server stop` |

The mouse works for everything: click panes, drag borders, right-click for menus. You don't need to memorize the keys on day one.

**Try it (10 min)**
1. In Ghostty: `cd ~/Projects/go-todos-htmx && herdr`.
2. Run `claude` in the pane. Watch the sidebar status change as it works.
3. `Ctrl+B` then `v` to split. In the new pane, run `git status`.
4. `Ctrl+B` then `q` to detach. **Quit Ghostty completely** (`Cmd+Q`).
5. Open Ghostty again and run `herdr`. Everything is still there, Claude included.

**When it breaks**
- *"Saved directory is unavailable"*: a workspace points at a deleted folder. Close it: right-click the workspace → close, or `herdr workspace list` then `herdr workspace close <id>`.
- Running `herdr` inside herdr is blocked on purpose. Use `tt` or a new workspace instead.
- An agent shows the wrong status: `herdr agent list`, then `herdr agent explain <pane-id>`.
- Config: `~/Dotfiles/home/dot_config/herdr/config.toml`. After `chezmoi apply`, run `herdr server reload-config`.
- Docs: <https://herdr.dev/docs/>

---

## 3. The AI agents

You have three CLI agents plus Copilot in VS Code. They are **interchangeable for most work**. Pick one as your main tool (Claude Code is a good default), and use the others for a second opinion or when you run out of quota.

| | Claude Code | GitHub Copilot CLI | Gemini CLI |
|---|---|---|---|
| Start | `claude` | `copilot` | `gemini` |
| Good at | Long multi-file changes, careful reasoning | GitHub work (PRs, issues, Actions), choosing among many models | Big context, quick questions |
| One-shot (no chat) | `claude -p "..."` | `copilot -p "..."`, or your `?? question` | `gemini -p "..."` |

### What all three share (set up once, in this repo)

| Shared thing | Source file | What it does |
|---|---|---|
| **Instructions** | `home/.chezmoitemplates/agents.md` | "Who I am, how I work": Herd for PHP, conventional commits, ask before pushing… |
| **Skills** | `home/dot_agents/skills/*/SKILL.md` | Step-by-step playbooks the agent loads **only when relevant**: `commit`, `code-review`, `pr-description`, `tdd`, `laravel-conventions`, `go-conventions`, `python-conventions`, `ts-js-conventions`, `notes-markdown`, `herdr`. |
| **Permissions** | `home/.chezmoidata/agents.yaml` | What runs without asking (tests, builds, `git status`), what always asks (`git commit`, `git push`, `rm`, `curl`, installs), and what's never allowed (`sudo`, `op`, reading `.env`/SSH keys/your secrets file). |
| **MCP servers** | same `agents.yaml` | Extra tools. `context7` gives agents up-to-date library docs. |

> **MCP** (Model Context Protocol) is a plug-in system that gives agents extra tools. You don't need to understand it; just know `context7` is there.

### Talking to an agent well

1. **Start in the project folder.** The agent sees that folder.
2. **Say what "done" looks like.** "Add a `DELETE /todos/{id}` endpoint with a test. Done = `go test ./...` passes."
3. **Point at files** with `@`: "Look at @handlers/todos.go".
4. **Ask for a plan first on big tasks.** "Plan it, don't code yet." In Claude, `Shift+Tab` switches to plan mode.
5. **Review before you commit.** Ask it to "review my changes" (uses the `code-review` skill), then "commit this" (uses the `commit` skill).
6. **Keep sessions short.** When a task is done, run `/clear` and start fresh. Long chats get confused.

### Keys and commands worth knowing

**Claude Code**

| | |
|---|---|
| Interrupt it | `Esc` |
| Rewind to an earlier message (undo) | `Esc` `Esc`, or `/rewind` |
| Cycle modes (normal → auto-accept edits → plan) | `Shift+Tab` |
| Run a shell command yourself | start the line with `!` |
| Mention a file | `@path/to/file` |
| New conversation | `/clear` |
| Shrink a long conversation | `/compact` |
| See skills / MCP / permissions | `/skills`, `/mcp`, `/permissions` |
| Create a project `CLAUDE.md` | `/init` |
| How full is the context? | `/context` |

**Copilot CLI**

| | |
|---|---|
| Help / all commands | `/help` |
| Pick a model | `/model` |
| Review your changes | `/review` (or `/security-review`) |
| See the diff it made | `/diff` |
| Undo to an earlier turn | `/rewind` |
| Move your work into a new worktree | `/move` |
| Pull request for this branch | `/pr` |
| Skills / MCP / instructions | `/skills`, `/mcp`, `/instructions` |
| Resume an old session | `copilot --resume`, or `/resume` |

> Your `copilot` command is a small wrapper (in `~/.config/zsh/agents.zsh`) that applies the shared allow/deny rules every time, because Copilot CLI has no permanent permissions file.

**Gemini CLI**: `/help`, `/skills list`, `/mcp`. It asks before editing until you **trust the folder** (it offers when you start in a new folder).

### Project-level instructions

Your global instructions apply everywhere. For project-specific rules ("use Pest, not PHPUnit"; "run `make test`"), add an **`AGENTS.md`** at the project root. All three agents read it. The quickest way to start one: run `claude` in the project, then `/init`, then rename or merge the result into `AGENTS.md`.

**Try it (15 min)**
1. `cd ~/Projects/go-todos-htmx && claude`
2. "Explain this project's structure in 10 bullet points."
3. "Add a test for one untested function."
4. Watch it run `go test` without asking (allowed), then say "commit this". It should **ask before committing**, because commits are in the ask list.
5. Type `/skills` and `/mcp` to see what's loaded.

**When it breaks**
- An agent ignores your instructions: check they're loaded. In Copilot: `copilot instruction list`. In Claude: `/memory`.
- Too many permission prompts: add the command to `allowCommands` in `agents.yaml`, then `chezmoi apply`. (For Copilot, add it under `copilot.allowTools`, then open a new shell.)
- Never use `--dangerously-skip-permissions` or `--yolo` outside a throwaway folder.

---

## 4. git worktrees and `wt`: agents in parallel

**What it is.** A *worktree* is a second checkout of the same repo, in another folder, on another branch. Two agents can work on two features at the same time without stepping on each other's files.

**Why you have it.** One agent per branch per folder means no conflicts and an easy review: each branch becomes its own PR.

**Your helper:** `wt <branch> [claude|copilot|gemini|none] [base]`

- **Inside herdr:** creates the worktree (under `~/.herdr/worktrees/`), opens it as a **new workspace**, and starts the agent (Claude by default).
- **Outside herdr:** creates `../<repo>--<branch>`, `cd`s there, and starts the agent.
- If the worktree already exists, it just goes back to it.

**The 20% you'll use daily**
```sh
wt feat/delete-todo            # new branch + worktree + Claude
wt fix/login-bug copilot       # same, with Copilot
git worktree list              # see all worktrees and their folders
git worktree remove <folder>   # delete one after merging (refuses if it has unsaved work)
git branch -d <branch>         # then delete the merged branch
```

**Try it.** In a herdr pane inside a repo, run `wt try/worktree none`. A new workspace appears in the sidebar. Run `git branch --show-current` there. To clean up: close that workspace, run `git worktree list` to find its folder, then `git worktree remove <folder>` and `git branch -d try/worktree`.

---

## 5. chezmoi: how your dotfiles work now

**What it is.** A dotfiles manager. The **source** lives in `~/Dotfiles` (a git repo, public on GitHub). chezmoi **renders** that source into your home folder: real files, templates filled with your data, symlinks, and secrets pulled from 1Password.

**Why you have it.** One command sets up a new Mac. Secrets stay out of git. One data file (`agents.yaml`) generates configs for three different agents.

### File naming (you'll see these in `~/Dotfiles/home/`)

| Source name | Becomes |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_config/git/config.tmpl` | `~/.config/git/config` (template: `{{ … }}` gets filled in) |
| `private_…` | file/folder readable only by you |
| `executable_notes` | `~/.local/bin/notes`, made executable |
| `symlink_nvim.tmpl` | `~/.config/nvim` → a symlink into `~/Dotfiles/config/nvim` |
| `modify_settings.json.tmpl` | merges managed keys into an app-owned JSON file |
| `.chezmoiscripts/run_onchange_*` | scripts that re-run when their inputs change (brew bundle, mise install…) |

**Two kinds of config:**
- **Rendered** (most of `home/`): edit in `~/Dotfiles`, then apply.
- **Symlinked** (`config/nvim`, `config/karabiner`, `config/vscode`): the app edits the repo file directly. Changes from LazyVim, Karabiner's UI or VS Code settings show up in `git diff`. No apply needed.

### The 20% you'll use daily

| Command | Alias | Does |
|---|---|---|
| `chezmoi diff` | `czd` | Show what *would* change in `~`. **Always run this first.** |
| `chezmoi apply` | `cza` | Make `~` match the repo |
| `chezmoi edit --apply ~/.zshrc` | `cze ~/.zshrc` | Open the **source** of a file; apply on save |
| `chezmoi add ~/.somerc` | | Start managing an existing file |
| `chezmoi re-add` | | You edited a managed file in `~` by mistake; copy it back into the repo |
| `chezmoi managed` | | List everything chezmoi manages |
| `chezmoi update` | | `git pull` + apply (on another Mac) |
| `chezmoi doctor` | | Health check |
| `dot` | | `cd ~/Dotfiles` |

Then commit like any repo: `git add -A && git commit` (or ask an agent: "commit this"). The **gitleaks** pre-commit hook blocks the commit if it sees a secret.

**Try it (10 min)**
1. `cze ~/.config/zsh/aliases.zsh`. Add `alias hi='echo hello'` and save. It applies automatically.
2. Open a new pane and type `hi`.
3. `dot && git diff` shows your change in the repo. Commit it, or undo it with `git checkout -- . && chezmoi apply`.

**When it breaks**
- *"…has changed since chezmoi last wrote it"*: you (or an app) edited the file in `~`. Run `chezmoi diff` to look; then `chezmoi re-add` to keep your edit, or `chezmoi apply --force` to discard it.
- A template error during apply: render one file to see the problem, e.g. `chezmoi execute-template < ~/Dotfiles/home/dot_config/git/config.tmpl`.
- 1Password errors on apply: unlock the 1Password app; check `op vault list` shows **Dev**.

---

## 6. 1Password CLI (`op`): secrets

**What it is.** The command line for your 1Password vault.

**Why you have it.** Passwords and tokens used to sit in plain text in `.zshrc`. That's dangerous because AI agents read config files. Now they live in the **Dev** vault, and chezmoi writes them to `~/.config/zsh/secrets.zsh` (only you can read it, and agents are blocked from reading it).

**The 20% you'll use**
```sh
op vault list                                   # check you're connected
op item list --vault Dev                        # what's in there
op read "op://Dev/GENAI_DB_DSN/credential"      # print one secret
 op item create --vault Dev --category "API Credential" \
  --title OPENAI_API_KEY credential='sk-...'    # add one (leading space = not saved in history)
```

**Adding a secret to your shell (3 steps):**
1. Create it in 1Password (command above, or in the app).
2. Add a line to `~/Dotfiles/home/dot_config/zsh/private_secrets.zsh.tmpl`:
   ```
   export OPENAI_API_KEY={{ onepasswordRead "op://Dev/OPENAI_API_KEY/credential" | squote }}
   ```
3. `chezmoi apply`, then open a new shell.

**Per-project secrets** (better for an API key only one project needs) use **direnv**: see §8.

> Tip: a command that starts with a **space** isn't saved to shell history (`hist_ignore_space`). Use it whenever you type a secret.

---

## 7. mise: language versions

**What it is.** One tool that installs and switches versions of node, python, go and more. It replaced nvm, pyenv and asdf.

**Why you have it.** One tool instead of three, faster shells, and agents get the **same** versions as you.

**Globals** (in `~/.config/mise/config.toml`): node 24, python 3.13, go 1.26. **PHP stays with Herd.**

**The 20% you'll use**
```sh
mise ls                     # what's installed / active here
mise use node@22            # pin node 22 for THIS project (writes mise.toml)
mise install                # install whatever this folder asks for
mise upgrade                # update installed tools
mise trust                  # allow a project's mise.toml (asked the first time)
mise doctor                 # health check
```
mise also reads `.nvmrc`, `.python-version` and `.go-version` files, so older projects keep working.

To change a **global** version, edit `~/Dotfiles/home/dot_config/mise/config.toml` and run `chezmoi apply`. It installs the new version for you. (`mise use -g` would edit the rendered file, and the next apply would overwrite it.)

**Try it.** `mkdir /tmp/mise-try && cd /tmp/mise-try && mise use node@22 && node -v && cd ~ && node -v`. The version changes when you leave the folder. Clean up: `rm -rf /tmp/mise-try`.

**When it breaks**
- Wrong version: `mise doctor`; `which node` should point into `~/.local/share/mise/`.
- Python projects: use **uv** (`uv sync`, `uv run pytest`). It uses mise's Python.

---

## 8. Small tools that make agents better

| Tool | What it is | The one thing to know |
|---|---|---|
| **direnv** | Loads a folder's `.envrc` when you `cd` in, unloads it when you leave | In a project: `echo 'export API_KEY=$(op read op://Dev/X/credential)' > .envrc && direnv allow`. The file holds only a *reference*, not the secret. |
| **delta** | Prettier `git diff` (syntax colors, line numbers) | Automatic. In a diff, `n`/`N` jump between files. |
| **lazygit** | Git in a full-screen UI | `lazygit` (or `Ctrl+B` `Alt+G` in herdr). `space` stage, `c` commit, `P` push, `?` help. Great for reviewing what an agent changed. |
| **gitleaks** | Secret scanner | Runs before every commit in `~/Dotfiles`. Scan any repo: `gitleaks git`. |
| **gh** | GitHub from the terminal | `gh pr create`, `gh pr checkout 12`, `gh run watch`. Agents use it too. |
| **zoxide** | Smart `cd` | `z go-todos` jumps to the best match. |
| **fzf** | Fuzzy picker | Used by `tt`, `fav`, `cdf`, `sshf`, `notes`. |

### Your shell shortcuts

| Command | Does |
|---|---|
| `?? <question>` | Quick answer from Copilot, runs nothing. `?? find files bigger than 1GB` |
| `wt <branch>` | Worktree + agent (§4) |
| `tt` | Open a project as a herdr workspace |
| `updater` | fzf menu: update dotfiles, brew, mise, agent CLIs, herdr, zsh plugins |
| `notes …` / `nt`, `note`, `omn`, `ns`, `on`, `bs` | Your notes workflow (`notes --help`) |
| `Esc` then `v` | Edit the current command in nvim. Great for long prompts. |
| `dot`, `pro`, `fav`, `cdf` | Jump to dotfiles / projects / favorites / subfolder |

---

## 9. AeroSpace: window tiling

**What it is.** A tiling window manager. Windows on a workspace are arranged side by side automatically, with no dragging. It replaced yabai, skhd and sketchybar.

**Why you have it.** Ghostty on one side and a browser or VS Code on the other, every time, without touching the mouse.

**Words:** AeroSpace **workspaces** are like macOS Spaces, but instant and named (`1`–`9`, `A`–`Z`). `Alt` is the `Option` key.

**The 20% you'll use daily**

| Action | Keys |
|---|---|
| Focus window left/down/up/right | `Alt+H` `Alt+J` `Alt+K` `Alt+L` |
| Move window left/down/up/right | `Alt+Shift+H/J/K/L` |
| Go to workspace 1–9 / A–Z | `Alt+1` … `Alt+9`, `Alt+<letter>` |
| Send window to workspace | `Alt+Shift+1` … / `Alt+Shift+<letter>` |
| Previous workspace (toggle) | `Alt+Tab` |
| Side by side ↔ stacked (accordion) | `Alt+/` ↔ `Alt+,` |
| Make window smaller / bigger | `Alt+-` / `Alt+=` |
| Service mode (then `Esc` reloads config) | `Alt+Shift+;` |

**A simple habit:** `1` = terminal (Ghostty), `2` = browser, `3` = VS Code, `4` = chat/mail. Send each app there once with `Alt+Shift+<n>`.

**Try it.** Open Ghostty and Firefox on workspace 1. They split the screen. Press `Alt+H` and `Alt+L` to switch between them, `Alt+Shift+L` to swap them, then `Alt+Shift+2` to send Firefox to workspace 2 and `Alt+2` to follow it.

**When it breaks**
- Keys do nothing: grant **Accessibility** permission (System Settings → Privacy & Security → Accessibility → AeroSpace).
- A window shouldn't tile (e.g. a dialog): it floats automatically for System Settings, 1Password and Karabiner. To add more, add an `[[on-window-detected]]` rule in `~/Dotfiles/home/dot_config/aerospace/aerospace.toml`.
- Apply config changes: `chezmoi apply`, then `Alt+Shift+;` followed by `Esc`.
- Run `~/Dotfiles/scripts/macos-defaults.sh` once. It sets the Mission Control options AeroSpace recommends (log out and back in afterwards).
- **Conflict note:** `Alt+H/J/K/L` now belong to AeroSpace everywhere. In Neovim, switch windows with the arrow keys or `Ctrl+W h/j/k/l`.

### Karabiner and Hammerspoon (unchanged)

- **Karabiner:** Caps Lock = `Esc` when tapped, `Ctrl` when held. `Ctrl+H/J/K/L` = arrow keys. Config lives in `config/karabiner/`, edited through the Karabiner app.
- **Hammerspoon:** shows a green bar while Korean input is active, and switches to English when you press `Esc` in Vim. Reload it from its menu-bar icon → Reload Config.

---

## 10. Tailscale + Ovis: your agents on your phone

**What they are.**
- **Tailscale** creates a **private network** between your devices (Mac, phone), wherever they are. Nothing is exposed to the internet.
- **Ovis** is a web app running on your Mac, on top of herdr. It shows your agents as chats and turns approval prompts into **Allow/Deny buttons**, with push alerts.

**Why you have them.** Start a long task, walk away, and approve the `git push` from your phone.

**How it's wired:** Ovis listens on `http://127.0.0.1:7317` (Mac only). `tailscale serve` publishes it as an HTTPS address that **only your Tailscale devices** can open. Find that address with:
```sh
tailscale serve status
```

**Daily use**
1. Ovis starts automatically with herdr. Make sure herdr is running (`herdr`, then detach).
2. On your phone: Tailscale **Connected**, then open the Ovis app from your home screen.
3. When an agent becomes **blocked**, you get an alert. Tap **Allow** or **Deny**.

**When it breaks**
- Phone can't load it: is Tailscale connected on **both** devices (`tailscale status`)? Is herdr running (`herdr status server`)?
- No alerts: in Ovis, **Settings → Alerts → Send test**.
- Updating Ovis: rerun its installer with Homebrew's curl, because macOS's built-in curl trips an installer bug:
  `curl -fsSL https://ovis.sh/install.sh | PATH="/opt/homebrew/opt/curl/bin:$PATH" sh`

---

## 11. A typical day, start to finish

```sh
# Morning
herdr                         # attach (open Ghostty → herdr)
tt                            # pick a project → new workspace

# Feature work
wt feat/export-csv            # worktree + Claude in a new workspace
# > "Add CSV export to /todos. Plan first."   (Shift+Tab for plan mode)
# > "Looks good, implement it. Done = go test ./... passes."
# …meanwhile, in another workspace…
wt fix/flaky-test copilot     # second agent, second branch

# Review
# > "review my changes"       (code-review skill)
#   Ctrl+B Alt+G → lazygit    look at the diff yourself
# > "commit this"             (commit skill; asks before committing)
# > "open a draft PR"         (pr-description skill; asks before pushing)

# Leaving
#   Ctrl+B q                  detach; agents keep going
#   phone: approve/deny via Ovis alerts
```

---

## 12. Four-week learning plan

Spend about **20 minutes a day**. Don't move on until the current week's tools feel normal.

**Week 1: terminal + one agent**
- [ ] §1 Ghostty: Shift+Enter, copy on select.
- [ ] §2 herdr: the "Try it", especially detach and re-attach.
- [ ] §3 Claude Code only: one small real task per day in a real project.
- [ ] Learn: `Esc`, `Esc Esc`, `Shift+Tab`, `/clear`, `@file`.

**Week 2: safety + git flow**
- [ ] §3 again: notice what runs without asking and what asks. Read `agents.yaml`.
- [ ] §4 worktrees: one feature per `wt` branch.
- [ ] §8 lazygit for reviewing; let the agent write commits with the `commit` skill.
- [ ] Try `copilot` for one task, and `/review` on your own diff.

**Week 3: your environment**
- [ ] §5 chezmoi: do the alias exercise, then change one real thing (e.g. add an allowed command).
- [ ] §6 1Password: add one secret the right way.
- [ ] §7 mise: pin a version in one project.
- [ ] §9 AeroSpace: one workspace per app, all week.

**Week 4: parallel + remote**
- [ ] Two agents in parallel on two `wt` branches.
- [ ] §10 Ovis: approve something from your phone.
- [ ] Write an `AGENTS.md` for your most-used project.
- [ ] Write your **own** skill: copy a folder in `home/dot_agents/skills/`, edit its `SKILL.md`, then `chezmoi apply`.

---

## 13. One-page cheat sheet

```
HERDR  (Ctrl+B, release, then…)          CLAUDE CODE
  q detach     ? help      v / - split     Esc stop       Esc Esc rewind
  h j k l move z zoom      x close pane    Shift+Tab mode @file mention
  c new tab    n / p tabs  w workspaces    !cmd shell     /clear /compact
  Shift+N new workspace    Alt+G lazygit   /skills /mcp /permissions /context

AEROSPACE (Alt = Option)                 SHELL
  Alt+H/J/K/L focus   +Shift move        wt <branch> [agent]   tt   ?? <q>
  Alt+1..9 / A..Z workspace +Shift send  Esc v  edit command in nvim
  Alt+Tab back   Alt+/ tiles  Alt+, stack updater   notes --help   dot

CHEZMOI                                  SECRETS
  czd diff → cza apply                     op read "op://Dev/<item>/credential"
  cze <file>   edit source + apply         add line to private_secrets.zsh.tmpl
  chezmoi re-add   keep an in-place edit   leading space = not in history

WHERE THINGS LIVE (~/Dotfiles)
  home/.chezmoitemplates/agents.md   agent instructions (all agents)
  home/.chezmoidata/agents.yaml      permissions + MCP (all agents)
  home/dot_agents/skills/            skills (all agents)
  home/dot_config/zsh/               shell
  Brewfile                           apps (auto-installed on change)
  config/nvim, config/vscode         editors (live symlinks)
```

## 14. When you're stuck

1. **Ask an agent.** Run `claude` in `~/Dotfiles`. It reads this repo's `AGENTS.md` and knows how everything fits together, so "why does X…?" works well. You can also point it at this guide: "read @docs/guide.md and help me with herdr".
2. **Health checks:** `chezmoi doctor`, `mise doctor`, `herdr status`, `tailscale status`, `op vault list`.
3. **Undo:** the repo is in git (`git log`, `git checkout`). A full backup of the old setup is at `~/Backups/dotfiles-2026-11-14.tar.gz`.
4. **Docs:** [herdr](https://herdr.dev/docs/) · [chezmoi](https://chezmoi.io/user-guide/command-overview/) · [mise](https://mise.jdx.dev/getting-started.html) · [AeroSpace](https://nikitabobko.github.io/AeroSpace/guide) · [Ghostty](https://ghostty.org/docs) · [Claude Code](https://docs.anthropic.com/en/docs/claude-code) · [Copilot CLI](https://docs.github.com/copilot/how-tos/use-copilot-agents/use-copilot-cli) · [Gemini CLI](https://geminicli.com/docs/) · [Ovis](https://github.com/devswha/ovis/blob/main/docs/guide.md)
