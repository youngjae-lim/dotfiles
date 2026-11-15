# Environment for every zsh. Sourced from ~/.zshenv, and again from ~/.zshrc
# because macOS /etc/zprofile (path_helper) reorders PATH for login shells.

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=ghostty

export DOTFILES_DIR="$HOME/Dotfiles"
export NVIM_DIR="$DOTFILES_DIR/config/nvim"
export PROJECTS_DIR="$HOME/Projects"
export GOOGLE_DRIVE_DIR="$HOME/Google Drive/My Drive"
export SHELL_TRASH_DIR="$HOME/.shell/trash"
export SHELL_PLUGIN_DIR="$HOME/.shell/zsh-plugins"
export BUN_INSTALL="$HOME/.bun"

# mise shims give non-interactive shells (agents, editors, scripts) the same
# runtimes; interactive shells switch to `mise activate` in ~/.zshrc.
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.local/share/mise/shims"
  "$HOME/Library/Application Support/Herd/bin"
  "$HOME/go/bin"
  "$HOME/.bun/bin"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $path
)
