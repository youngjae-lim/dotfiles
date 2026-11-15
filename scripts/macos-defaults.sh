#!/usr/bin/env bash
# macOS preferences. Run manually on a new machine: ~/Dotfiles/scripts/macos-defaults.sh
set -euo pipefail

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
defaults write com.apple.dock showhidden -bool true
# AeroSpace: group windows by app in Mission Control so workspaces render sanely.
defaults write com.apple.dock expose-group-apps -bool true
killall Dock

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder DisableAllAnimations -bool true
killall Finder

# AeroSpace recommends turning off "Displays have separate Spaces".
defaults write com.apple.spaces spans-displays -bool true

# Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
defaults write com.apple.screencapture type -string "jpg"

echo "macOS settings applied. Log out and back in for Spaces changes to take effect."
