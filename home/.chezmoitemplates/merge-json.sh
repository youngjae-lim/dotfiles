#!/bin/sh
# chezmoi modify_ script body. Merges managed JSON into the existing file so
# keys the app writes itself (state, UI prefs) are preserved. Called with:
#   managed    object deep-merged into the file. Managed keys win; managed
#              arrays replace existing arrays.
#   owned      (optional) top-level keys of `managed` that replace the existing
#              value wholesale instead of merging, so an entry removed from
#              agents.yaml (e.g. an MCP server) is removed from the file too.
#   extra      (optional) jq program applied after the merge, with
#   extraData  bound to $extra.
set -eu
JQ=$(command -v jq || echo /opt/homebrew/bin/jq)
current=$(cat)
[ -n "$current" ] || current='{}'
managed=$(cat <<'CHEZMOI_MANAGED_JSON'
{{ .managed | toPrettyJson }}
CHEZMOI_MANAGED_JSON
)
owned='{{ .owned | default (list) | toJson }}'
extra=$(cat <<'CHEZMOI_EXTRA_JSON'
{{ .extraData | default (dict) | toPrettyJson }}
CHEZMOI_EXTRA_JSON
)
program='. * $managed | reduce $owned[] as $k (.; .[$k] = $managed[$k])'
{{- with .extra }}
program="$program | $(cat <<'CHEZMOI_EXTRA_JQ'
{{ . }}
CHEZMOI_EXTRA_JQ
)"
{{- end }}
printf '%s' "$current" |
  "$JQ" --argjson managed "$managed" --argjson owned "$owned" --argjson extra "$extra" "$program"
