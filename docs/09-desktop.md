# 9. Windows, keyboard and phone

[← Languages and small tools](08-languages-and-tools.md) · Next: [A day with this setup →](10-daily-workflow.md)

## AeroSpace: window tiling

**What it is.** A **tiling window manager**: it arranges the windows on a screen side by side automatically, with no dragging or resizing by hand. It replaced yabai, skhd and sketchybar.

**Why you have it.** Ghostty on one side and a browser or VS Code on the other, every time, without touching the mouse.

**Words.** An AeroSpace **workspace** is like a macOS Space (a virtual desktop), but instant to switch to and named: `1`–`9`, `A`–`Z`. `Alt` is the `Option` key.

```mermaid
flowchart LR
    subgraph BIG["32-inch monitor"]
        direction TB
        T["Alt+T · Terminal<br/>Claude + Ghostty"]:::output
        C["Alt+C · Code<br/>VS Code"]:::step
        D["Alt+D · Data<br/>DBeaver, Docker"]:::step
    end
    subgraph SMALL["27-inch monitor"]
        direction TB
        B["Alt+B · Browser<br/>Chrome Personal"]:::output
        W["Alt+W · Work<br/>Chrome Work"]:::step
        R["Alt+R · Reading"]:::step
        M["Alt+M · Messages"]:::step
    end
    BIG ~~~ SMALL
    classDef step fill:#f1f5f9,stroke:#64748b,color:#1e293b
    classDef output fill:#dcfce7,stroke:#15803d,color:#052e16
    style BIG fill:#f8fafc,stroke:#94a3b8,color:#1e293b
    style SMALL fill:#f8fafc,stroke:#94a3b8,color:#1e293b
```

Each monitor shows **one** of its workspaces at a time (green here); the others are one keypress away (grey).

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

Workspaces are named with **letters you can remember**. Most apps open on their own letter automatically, and the main ones are **pinned** to a monitor, so `Alt+T` always lands on the big screen and `Alt+B` on the small one.

| Key | Mnemonic | Opens there automatically | Monitor |
|---|---|---|---|
| **`T`** | **T**erminal | Claude desktop (open Ghostty here; it sits beside Claude) | 32" |
| **`C`** | **C**ode | VS Code | 32" |
| **`D`** | **D**ata | DBeaver, Beekeeper Studio, Docker Desktop | 32" |
| **`B`** | **B**rowser | Chrome **Personal** profile, Firefox | 27" |
| **`W`** | **W**ork | Chrome **Work** profile | 27" |
| **`R`** | **R**eading | nothing automatic: send docs and PDFs here | 27" |
| **`M`** | **M**essages | Mail, Messages, Slack, KakaoTalk | 27" |
| **`Z`** | **Z**oom | Zoom (floating, not tiled) | whichever has focus |
| **`N`** | **N**otes | Apple Notes | whichever has focus |
| `1`–`9` | scratch | nothing: use for anything temporary | whichever has focus |

- **Go** to a workspace: `Alt+<letter>`. **Send** the current window there: `Alt+Shift+<letter>`.
- **Ghostty has no automatic rule** on purpose. `Alt+Enter` opens a new terminal *where you are*; with a rule, every new terminal would jump to `T`.
- **Chrome's two profiles** are told apart by the end of the window title: `(Work)` goes to `W`, everything else to `B`. Chrome sometimes sets the title a moment after the window appears, so a Work window occasionally lands on `B`: press `Alt+Shift+W`.
- **Moving a whole workspace** to the other monitor for a while (say, Zoom onto the big screen): `Alt+Shift+Tab`.
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
