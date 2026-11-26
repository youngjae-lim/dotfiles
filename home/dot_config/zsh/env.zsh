# Environment for every zsh. Sourced from ~/.zshenv, and again from ~/.zshrc
# because macOS /etc/zprofile (path_helper) reorders PATH for login shells.
# Shared by the Mac and the spare Ubuntu machines: paths that don't exist on
# one of them are simply skipped by the shell.

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

# One look for every fzf picker (notes, apps, updater, cdf…): separate boxes for
# the search line, header and list, no outer frame, and at most 60% of the
# screen (~ = shrink to fit short lists). Colours are terminal palette numbers,
# so they follow the Ghostty theme. Docs: chapter 8, "fzf".
export FZF_DEFAULT_OPTS="--style=full --border=none --height=~60% --layout=reverse --cycle \
--info=inline-right --highlight-line --prompt='❯ ' --pointer='▌' --marker='✓' \
--color=bg+:0,fg+:15:bold,hl:3:bold,hl+:3:bold,border:8,label:4:bold,header:4 \
--color=prompt:5,pointer:5,marker:2,info:8,spinner:5"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"

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
  /home/linuxbrew/.linuxbrew/bin
  /home/linuxbrew/.linuxbrew/sbin
  $path
)
