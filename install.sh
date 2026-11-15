#!/bin/sh
# Bootstrap a new Mac:
#   sh -c "$(curl -fsLS https://raw.githubusercontent.com/youngjae-lim/dotfiles/main/install.sh)"
set -eu

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

chezmoi init --apply --source "$HOME/Dotfiles" https://github.com/youngjae-lim/dotfiles.git
git -C "$HOME/Dotfiles" config core.hooksPath .githooks
echo "Done. Open Ghostty and run: herdr"
