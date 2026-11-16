#!/bin/bash
# Claude Code Notification hook: a macOS notification when Claude is waiting
# on you (a permission prompt, or idle waiting for input), so an agent in a
# background herdr pane doesn't sit unnoticed.
set -uo pipefail
[[ $(uname) == Darwin ]] || exit 0
JQ=$(command -v jq || echo /opt/homebrew/bin/jq)

input=$(cat)
msg=$("$JQ" -r '.message // empty' <<<"$input" 2>/dev/null)
dir=$("$JQ" -r '.cwd // empty' <<<"$input" 2>/dev/null)
title="Claude Code${dir:+ · ${dir##*/}}"

msg=${msg:-Claude Code needs your attention}

# terminal-notifier (Brewfile): clicking the notification brings Ghostty to the
# front, and -group replaces an older alert from the same project instead of
# stacking them.
if command -v terminal-notifier >/dev/null; then
  terminal-notifier -title "$title" -message "$msg" -sound Glass \
    -activate com.mitchellh.ghostty -group "claude-${dir:-default}" >/dev/null 2>&1 || true
  exit 0
fi

# Fallback: osascript works everywhere, but macOS credits the notification to
# Script Editor, so clicking it opens Script Editor. Text is passed as
# arguments, not inside the script, so quotes can't break it.
osascript \
  -e 'on run argv' \
  -e 'display notification (item 1 of argv) with title (item 2 of argv) sound name "Glass"' \
  -e 'end run' \
  "$msg" "$title" >/dev/null 2>&1 || true
exit 0
