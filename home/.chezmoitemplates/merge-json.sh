#!/bin/sh
# chezmoi modify_ script body. Deep-merges the managed JSON below into the
# existing file so keys the app writes itself (state, UI prefs) are preserved.
# Managed keys win; managed arrays replace existing arrays.
set -eu
JQ=$(command -v jq || echo /opt/homebrew/bin/jq)
current=$(cat)
[ -n "$current" ] || current='{}'
managed=$(cat <<'CHEZMOI_MANAGED_JSON'
{{ . | toPrettyJson }}
CHEZMOI_MANAGED_JSON
)
printf '%s' "$current" | "$JQ" --argjson managed "$managed" '. * $managed'
