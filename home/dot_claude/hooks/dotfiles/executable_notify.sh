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

# Pass text as arguments, not inside the script, so quotes can't break it.
osascript \
  -e 'on run argv' \
  -e 'display notification (item 1 of argv) with title (item 2 of argv) sound name "Glass"' \
  -e 'end run' \
  "${msg:-Claude Code needs your attention}" "$title" >/dev/null 2>&1 || true
exit 0
