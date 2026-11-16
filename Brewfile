# Applied by chezmoi (home/.chezmoiscripts/darwin/run_onchange_before_10-brew-bundle.sh.tmpl)
# whenever this file changes. Manual: brew bundle --file ~/Dotfiles/Brewfile
# Not here on purpose: Claude Code (native installer, self-updates), VS Code,
# 1Password app, Herd (installed from their own installers).

tap "nikitabobko/tap"
tap "homebrew-zathura/zathura"

# --- Agents & terminal workflow ---
cask "ghostty"
brew "herdr"
cask "copilot-cli"
brew "gemini-cli"
cask "1password-cli"
cask "tailscale-app"

# --- Core CLI ---
brew "git"
brew "gh"
brew "git-delta"
brew "gitleaks"
brew "lazygit"
brew "chezmoi"
brew "mise"
brew "direnv"
brew "uv"
brew "neovim"
brew "tmux"
brew "bat"
brew "eza"
brew "fd"
brew "fzf"
brew "ripgrep"
brew "zoxide"
brew "jq"
brew "tree"
brew "wget"
brew "make"
brew "gnu-sed"
brew "lf"
brew "lua"
brew "shellcheck"
brew "stylua"
brew "terminal-notifier" # Claude "waiting on you" alerts (hooks/dotfiles/notify.sh)
brew "htop"
brew "figlet"

# --- Languages & data (runtimes for node/python/go come from mise; PHP from Herd) ---
brew "composer"
brew "pnpm"
brew "elixir"
brew "golang-migrate"
brew "postgresql@14", restart_service: :changed
brew "mysql"

# --- Notes / docs ---
brew "pandoc"
brew "pygments"
brew "homebrew-zathura/zathura/zathura"
brew "homebrew-zathura/zathura/zathura-pdf-poppler"

# --- macOS apps ---
cask "nikitabobko/tap/aerospace"
cask "karabiner-elements"
cask "hammerspoon"
cask "docker-desktop"
cask "firefox"
cask "stats"
cask "dbeaver-community"
cask "beekeeper-studio"
