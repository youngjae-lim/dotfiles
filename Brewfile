# Applied by chezmoi (home/.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl)
# whenever this file changes. Manual: brew bundle --file ~/Dotfiles/Brewfile
# Not here on purpose: Claude Code (native installer, self-updates), VS Code,
# 1Password app, Herd (installed from their own installers).
#
# Two kinds of machine read this file: the Mac, and the spare Ubuntu machines
# (Homebrew on Linux, docs chapter 14). Everything outside the `if OS.mac?`
# block below must install on both. Mac-only lines (casks, taps, macOS apps)
# go inside the block, and so do their taps, indented.

# --- Agents & terminal workflow ---
brew "herdr"
brew "gemini-cli"

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
brew "elixir-ls"   # Elixir language server (brings elixir + mix); used by Neovim
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
brew "lf"
brew "lua"
brew "shellcheck"
brew "stylua"
brew "htop"
brew "figlet"
brew "exiftool"   # read/write photo metadata (EXIF, XMP, IPTC)
brew "rclone"     # encrypted drive backups to Backblaze B2 (drive-backup)

# --- Languages & data (runtimes for node/python/go come from mise; PHP from Herd) ---
brew "composer"
brew "pnpm"
brew "elixir"
brew "golang-migrate"

# --- Notes / docs ---
brew "pandoc"
brew "pygments"

if OS.mac?
  tap "nikitabobko/tap"
  tap "homebrew-zathura/zathura"
  tap "FelixKratz/formulae"
  tap "deskflow/tap"

  # Agents & terminal workflow (on Linux: install.sh installs Copilot with its
  # own script, and 1Password and Tailscale from their apt repositories)
  cask "ghostty"
  cask "copilot-cli"
  cask "1password-cli"
  cask "tailscale-app"

  # GNU tools macOS lacks (Linux has its own)
  brew "make"
  brew "gnu-sed"
  brew "terminal-notifier" # Claude "waiting on you" alerts (hooks/dotfiles/notify.sh)

  # Database servers: on the Mac only; the spares don't run projects' databases
  brew "postgresql@14", restart_service: :changed
  brew "mysql"

  # PDF reader for notes (on Linux: apt install zathura zathura-pdf-poppler)
  brew "homebrew-zathura/zathura/zathura"
  brew "homebrew-zathura/zathura/zathura-pdf-poppler"

  # macOS apps
  cask "nikitabobko/tap/aerospace"
  brew "borders" # JankyBorders: green outline on the focused window (started by AeroSpace)
  cask "karabiner-elements"
  cask "hammerspoon"
  cask "docker-desktop"
  cask "firefox"
  cask "stats"
  cask "dbeaver-community"
  cask "beekeeper-studio"
  cask "deskflow/tap/deskflow" # one keyboard and mouse for the M2 and the Mac mini (docs chapter 14)
end
