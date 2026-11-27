#!/bin/sh
# Bootstrap a new machine: the Mac, or a spare Ubuntu machine (docs chapter 14).
#   sh -c "$(curl -fsLS https://raw.githubusercontent.com/youngjae-lim/dotfiles/main/install.sh)"
# To try a branch before merging it, name it twice (the URL and DOTFILES_BRANCH):
#   DOTFILES_BRANCH=feat/x sh -c "$(curl -fsLS https://raw.githubusercontent.com/youngjae-lim/dotfiles/feat/x/install.sh)"
set -eu

REPO=https://github.com/youngjae-lim/dotfiles.git
BRANCH=${DOTFILES_BRANCH:-main}

mac() {
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

  brew install chezmoi jq
  brew install --cask 1password 1password-cli

  cat <<'MSG'

Before continuing:
  1. Open 1Password and sign in.
  2. Settings → Developer → enable "Integrate with 1Password CLI".
  3. Check: `op vault list` shows the "Dev" vault.
MSG
  printf 'Press Enter when done... '
  read -r _

  chezmoi init --apply --branch "$BRANCH" --source "$HOME/Dotfiles" "$REPO"
  # Once more: during the first apply, herdr adds its hook to Claude's
  # settings.json after chezmoi wrote it, which `chezmoi status` would show
  # as MM until the next apply. This settles it, so a new machine ends clean.
  chezmoi apply
  git -C "$HOME/Dotfiles" config core.hooksPath .githooks
  echo "Done. Open Ghostty and run: herdr"
}

# Spare Ubuntu machines: the shell, Neovim, mise, herdr and the agents, but none
# of the Mac's desktop apps. Safe to run again: each step skips what's there.
linux() {
  command -v apt-get >/dev/null 2>&1 || {
    echo "install.sh: on Linux, only Ubuntu/Debian (apt) is supported" >&2
    exit 1
  }
  # A desktop (graphical login) also gets the 1Password app, the zathura PDF
  # reader for notes, clipboard tools for Neovim, Deskflow (the M2's keyboard
  # and mouse), GNOME's extensions (Auto Move Windows) and Chrome (docs
  # chapter 14). Over SSH it's the same.
  desktop=false
  [ "$(systemctl get-default 2>/dev/null || true)" = graphical.target ] && desktop=true

  echo "==> System packages (asks for your password)"
  sudo apt-get update
  # Homebrew's own requirements, plus zsh and gnupg (for the 1Password key)
  sudo apt-get install -y build-essential procps curl file git zsh gnupg
  if $desktop; then
    sudo apt-get install -y zathura zathura-pdf-poppler xclip wl-clipboard deskflow gnome-shell-extensions
    # Chrome, as on the M2. Google's package also adds its apt repository, so
    # `sudo apt upgrade` keeps it updated.
    if ! command -v google-chrome >/dev/null 2>&1 && [ "$(dpkg --print-architecture)" = amd64 ]; then
      deb=$(mktemp -d)/google-chrome.deb
      curl -fsSL -o "$deb" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
      sudo apt-get install -y "$deb"
      rm -f "$deb"
    fi
  fi

  echo "==> Homebrew"
  if [ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    sudo -v # NONINTERACTIVE can't ask for the password, so refresh sudo first
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install chezmoi jq

  echo "==> 1Password (apt repository, as support.1password.com/install-linux describes)"
  if ! command -v op >/dev/null 2>&1; then
    if [ "$(dpkg --print-architecture)" = amd64 ]; then
      curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        sudo gpg --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
      echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' |
        sudo tee /etc/apt/sources.list.d/1password.list >/dev/null
      sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
      curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
        sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol >/dev/null
      sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
      curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        sudo gpg --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
      sudo apt-get update
      if $desktop; then sudo apt-get install -y 1password 1password-cli; else sudo apt-get install -y 1password-cli; fi
    else
      echo "install.sh: skipping 1Password (only amd64 here); drive-backup restore needs it" >&2
    fi
  fi

  echo "==> Tailscale"
  command -v tailscale >/dev/null 2>&1 || curl -fsSL https://tailscale.com/install.sh | sh

  echo "==> Agents (their own installers, which keep them updated)"
  command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash
  command -v copilot >/dev/null 2>&1 || curl -fsSL https://gh.io/copilot-install | bash

  echo "==> Dotfiles (chezmoi asks for your name and email once; the Brewfile and"
  echo "    mise tools install now, which takes a while on older hardware)"
  chezmoi init --apply --branch "$BRANCH" --source "$HOME/Dotfiles" "$REPO"
  # Once more: during the first apply, herdr adds its hook to Claude's
  # settings.json after chezmoi wrote it, which `chezmoi status` would show
  # as MM until the next apply. This settles it, so a new machine ends clean.
  chezmoi apply
  git -C "$HOME/Dotfiles" config core.hooksPath .githooks

  echo "==> zsh as your login shell"
  if [ "$(getent passwd "$USER" | cut -d: -f7)" != /usr/bin/zsh ]; then
    sudo chsh -s /usr/bin/zsh "$USER"
  fi

  cat <<'MSG'

Done. Next:
  1. Log out and back in (or reconnect SSH) so zsh starts.
  2. Sign in once each: gh auth login · claude · copilot
     (gemini can't sign in with a personal Google account any more)
  3. Tailscale, if this machine is new to it: sudo tailscale up
  4. 1Password, for drive-backup restore:
       with a desktop: open 1Password and sign in; Settings → Security →
       "Unlock using system authentication" first, then Settings → Developer
       → "Integrate with 1Password CLI"; check with: op vault list
       over SSH only:  op account add, then eval "$(op signin)" before using it
  5. With a desktop: in the terminal's Preferences, turn off the system font
     and pick "JetBrainsMono Nerd Font Mono", size 11 (icons need it)
  6. Run: herdr
MSG
}

case "$(uname -s)" in
Darwin) mac ;;
Linux) linux ;;
*)
  echo "install.sh: unsupported system $(uname -s)" >&2
  exit 1
  ;;
esac
