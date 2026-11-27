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
  files=(install.sh .githooks/pre-commit scripts/*.sh home/dot_claude/hooks/dotfiles/executable_*.sh)
  # ~/.local/bin holds Python scripts too; check only the shell ones
  for f in home/private_dot_local/bin/executable_*; do
    head -n1 "$f" | grep -qE '^#!.*(ba)?sh' && files+=("$f")
  done
  # Templated shell scripts are checked after rendering, once as the Mac sees
  # them and once as the spare Ubuntu machines do.
  if command -v "$CHEZMOI" >/dev/null 2>&1; then
    for os in darwin linux; do
      for t in home/.chezmoiscripts/run_onchange_after_30-agent-integrations.sh.tmpl \
        home/.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl \
        home/.chezmoiscripts/run_onchange_after_15-nerd-font.sh.tmpl \
        home/dot_claude/hooks/dotfiles/executable_guard-secrets.sh.tmpl; do
        out="$tmp/$os-$(basename "$t" .tmpl)"
        "$CHEZMOI" --source . execute-template --override-data "{\"chezmoi\":{\"os\":\"$os\"}}" \
          <"$t" >"$out" || continue
        # A script meant for the other system renders empty; chezmoi skips those.
        grep -q '[^[:space:]]' "$out" && files+=("$out")
      done
    done
  fi
  if shellcheck "${files[@]}"; then echo "ok   ${#files[@]} scripts"; else status=1; fi
fi

echo
echo "== stylua"
if have stylua; then
  if stylua --check config/nvim home/dot_hammerspoon; then echo "ok   lua formatting"; else status=1; fi
fi

echo
echo "== gitleaks"
if have gitleaks; then
  gitleaks git --no-banner --redact . || status=1
fi

echo
if ((status)); then echo "check.sh: FAILED"; else echo "check.sh: all checks passed"; fi
exit "$status"
