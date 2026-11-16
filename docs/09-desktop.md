# 9. Windows, keyboard and phone

[← Languages and small tools](08-languages-and-tools.md) · Next: [A day with this setup →](10-daily-workflow.md)

## AeroSpace: window tiling

**What it is.** A **tiling window manager**: it arranges the windows on a screen side by side automatically, with no dragging or resizing by hand. It replaced yabai, skhd and sketchybar.

**Why you have it.** Ghostty on one side and a browser or VS Code on the other, every time, without touching the mouse.

**Words.** An AeroSpace **workspace** is like a macOS Space (a virtual desktop), but instant to switch to and named: `1`–`9`, `A`–`Z`. `Alt` is the `Option` key.

```mermaid
flowchart LR
    subgraph BIG["32-inch, landscape: windows side by side"]
        direction TB
        T1["Claude"]:::output
        T2["Ghostty"]:::output
    end
    subgraph SMALL["27-inch, portrait: windows stacked"]
        direction LR
        B1["Chrome"]:::output
        B2["Chrome"]:::output
    end
    BIG ~~~ SMALL
    classDef output fill:#dcfce7,stroke:#15803d,color:#052e16
    style BIG fill:#f8fafc,stroke:#94a3b8,color:#1e293b
    style SMALL fill:#f8fafc,stroke:#94a3b8,color:#1e293b
```

Each monitor shows **one** workspace at a time. Here the 32-inch shows `T` (Claude and Ghostty) and the 27-inch shows `B` (two Chrome windows). Any workspace can go on either monitor.

**The 20% you'll use**

| Action | Keys |
|---|---|
| **New Ghostty window** | `Alt+Enter` |
| **Make this window fill the screen** (press again to go back) | `Alt+Shift+Enter` |
| Focus window left/down/up/right | `Alt+H` `Alt+J` `Alt+K` `Alt+L` |
| Move window left/down/up/right | `Alt+Shift+H/J/K/L` |
| Go to workspace 1–9 / A–Z | `Alt+1` … `Alt+9`, `Alt+<letter>` |
| Send window to workspace | `Alt+Shift+1` … / `Alt+Shift+<letter>` |
| Previous workspace (toggle) | `Alt+Tab` |
| Side by side ↔ stacked | `Alt+/` ↔ `Alt+,` |
| Make window smaller / bigger | `Alt+-` / `Alt+=` |
| **Make all windows equal size again** | `Alt+Shift+=` |
| Service mode (then `Esc` reloads config) | `Alt+Shift+;` |

### Your workspaces: one letter per job

Workspaces are named with **letters you can remember**, and most apps open on their own letter automatically.

| Key | Mnemonic | Opens there automatically |
|---|---|---|
| **`T`** | **T**erminal | Claude desktop (open Ghostty here; it sits beside Claude) |
| **`C`** | **C**ode | VS Code |
| **`D`** | **D**ata | DBeaver, Beekeeper Studio, Docker Desktop |
| **`B`** | **B**rowser | Chrome **Personal** profile, Firefox |
| **`W`** | **W**ork | Chrome **Work** profile |
| **`R`** | **R**eading | nothing automatic: send docs and PDFs here |
| **`M`** | **M**essages | Mail, Messages, Slack, KakaoTalk |
| **`Z`** | **Z**oom | Zoom (floating, not tiled) |
| **`N`** | **N**otes | Apple Notes |
| `1`–`9` | scratch | nothing: use for anything temporary |

**Workspaces aren't tied to a monitor.** Any workspace can show on either one:

- **Go** to a workspace: `Alt+<letter>`. It appears on the monitor you're focused on. If it's already showing on the *other* monitor, your focus jumps there instead.
- **Send** the current window to a workspace: `Alt+Shift+<letter>`.
- **Move the whole workspace** to the other monitor: `Alt+Shift+Tab`. Handy for putting the browser, or a Zoom call, on the big screen for a while.
- **Switch focus between monitors:** keep pressing `Alt+H` / `Alt+L`. At the edge of one monitor, focus carries on to the next, in the direction the monitors are arranged in System Settings → Displays.

A layout that works well: `T` on the 32-inch, `B` or `W` on the 27-inch.

**The portrait 27-inch.** Your config sets `default-root-container-orientation = 'auto'`: on a wide monitor, windows sit side by side; on a tall one, they **stack top and bottom**. So the same workspace looks different depending on which monitor shows it. `Alt+/` flips between side by side and stacked if you want the other arrangement.
- **Ghostty has no automatic rule** on purpose. `Alt+Enter` opens a new terminal *where you are*; with a rule, every new terminal would jump to `T`.
- **Chrome's two profiles** are told apart by the end of the window title: `(Work)` goes to `W`, everything else to `B`. Chrome sometimes sets the title a moment after the window appears, so a Work window occasionally lands on `B`: press `Alt+Shift+W`.
- **Adding an app:** run `aerospace list-apps` to find its **bundle ID** (the unique name macOS gives each app, like `com.google.Chrome`), then copy one of the `[[on-window-detected]]` rules in `aerospace.toml`. Rules are checked top to bottom and the first match wins.

**Try it.** Open Ghostty and Firefox on workspace 1. They split the screen. Press `Alt+H` and `Alt+L` to switch between them, `Alt+Shift+L` to swap them, then `Alt+Shift+2` to send Firefox to workspace 2 and `Alt+2` to follow it.

**Changing its settings:** `home/dot_config/aerospace/aerospace.toml` (lane 1). [Chapter 2](02-chezmoi-basics.md#worked-example-change-a-setting-end-to-end) walks through a full change using this file as the example.

**When it breaks**
- **Empty gaps where windows should be.** Some windows are in a *different macOS Space*: either a window in macOS **native full screen** (the green button, or `Ctrl+Cmd+F`), or a window on a second macOS Desktop. AeroSpace still reserves room for them. Fix: open Mission Control (`Ctrl+↑`), take full-screen windows out of full screen with `Ctrl+Cmd+F`, and remove extra Desktops with the **×** on their thumbnails. Keep **one macOS Desktop per monitor**, and use `Alt+Shift+Enter` for full screen instead. `aerospace list-windows --workspace focused` shows every window AeroSpace thinks is on the current workspace.
- An app opens on the wrong workspace: check its bundle ID with `aerospace list-apps` against the rules in `aerospace.toml`.
- Keys do nothing: grant **Accessibility** permission (System Settings → Privacy & Security → Accessibility → AeroSpace).
- A window shouldn't tile (e.g. a dialog): it floats automatically for System Settings, 1Password and Karabiner. To add more, add an `[[on-window-detected]]` rule to `aerospace.toml`.
- Run `~/Dotfiles/scripts/macos-defaults.sh` once. It sets the Mission Control options AeroSpace recommends (log out and back in afterwards).
- **Conflict note:** `Alt+H/J/K/L` belong to AeroSpace everywhere. In Neovim, switch windows with the arrow keys or `Ctrl+W h/j/k/l`.

## Karabiner and Hammerspoon

- **Karabiner-Elements** changes what keys do. Caps Lock = `Esc` when tapped, `Ctrl` when held. `Ctrl+H/J/K/L` = arrow keys. Its config is in lane 2 (`config/karabiner/`): change it in the Karabiner app and the change shows up in `git diff`.
- **Hammerspoon** runs small Lua scripts that automate macOS. Yours shows a green bar while Korean input is active, and switches to English when you press `Esc` in Vim. Config: `home/dot_hammerspoon/` (lane 1). Reload it from its menu-bar icon → Reload Config.

## Tailscale + Ovis: your agents on your phone

**What they are.**
- **Tailscale** creates a **private network** between your own devices (Mac, phone), wherever they are. Nothing is exposed to the public internet.
- **Ovis** is a web app running on your Mac, on top of herdr. It shows your agents as chats and turns their approval prompts into **Allow / Deny** buttons, with push alerts.

**Why you have them.** Start a long task, walk away, and approve the `git push` from your phone.

```mermaid
flowchart LR
    PH["Your phone<br/>(Ovis app)"]:::step <-->|"Tailscale<br/>private network"| OV["Ovis on your Mac<br/>port 7317"]:::step
    OV <--> HD["herdr"]:::step
    HD <--> AG["Your agents"]:::agent
    classDef step fill:#f1f5f9,stroke:#64748b,color:#1e293b
    classDef agent fill:#ffedd5,stroke:#c2410c,color:#431407
```

**How it's wired:** Ovis listens on `http://127.0.0.1:7317`, which only your Mac can reach. `tailscale serve` publishes it as an HTTPS address that **only your Tailscale devices** can open. Find the address with `tailscale serve status`.

**Daily use**
1. Ovis starts with herdr. Make sure herdr is running (`herdr`, then detach).
2. On your phone: Tailscale **Connected**, then open Ovis from your home screen.
3. When an agent is **blocked** (waiting for you), you get an alert. Tap **Allow** or **Deny**.

**When it breaks**
- Phone can't load it: is Tailscale connected on **both** devices (`tailscale status`)? Is herdr running (`herdr status server`)?
- No alerts: in Ovis, **Settings → Alerts → Send test**.
- Updating Ovis: rerun its installer with Homebrew's curl, because macOS's built-in curl trips an installer bug:
  `curl -fsSL https://ovis.sh/install.sh | PATH="/opt/homebrew/opt/curl/bin:$PATH" sh`

Next: [A day with this setup →](10-daily-workflow.md)
