#!/usr/bin/env bash
# Validate the repo: agent-config parity, shellcheck, stylua, gitleaks.
# The one command to run before committing (agents: run this, then report it).
# Locally a missing tool is skipped; in CI (CI=true) it is a failure.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

CHEZMOI=${CHEZMOI:-chezmoi}
export CHEZMOI
status=0
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

have() {
  command -v "$1" >/dev/null 2>&1 && return 0
  if [[ ${CI:-} == true ]]; then
    echo "FAIL $1 is not installed"
    status=1
  else
    echo "skip $1 (not installed)"
  fi
  return 1
}

echo "== agent configs vs agents.yaml"
if have "$CHEZMOI" && have jq && have python3; then
  python3 scripts/check-agents.py || status=1
fi

echo
echo "== shellcheck"
if have shellcheck; then
  files=(install.sh .githooks/pre-commit scripts/*.sh home/private_dot_local/bin/executable_*
    home/dot_claude/hooks/dotfiles/executable_*.sh)
  # Templated shell scripts are checked after rendering.
  if command -v "$CHEZMOI" >/dev/null 2>&1; then
    for t in home/.chezmoiscripts/run_onchange_after_30-agent-integrations.sh.tmpl \
      home/dot_claude/hooks/dotfiles/executable_guard-secrets.sh.tmpl; do
      out="$tmp/$(basename "$t" .tmpl)"
      "$CHEZMOI" --source . execute-template <"$t" >"$out" && files+=("$out")
    done
  fi
  shellcheck "${files[@]}" && echo "ok   ${#files[@]} scripts" || status=1
fi

echo
echo "== stylua"
if have stylua; then
  stylua --check config/nvim home/dot_hammerspoon && echo "ok   lua formatting" || status=1
fi

echo
echo "== gitleaks"
if have gitleaks; then
  gitleaks git --no-banner --redact . || status=1
fi

echo
if ((status)); then echo "check.sh: FAILED"; else echo "check.sh: all checks passed"; fi
exit "$status"
