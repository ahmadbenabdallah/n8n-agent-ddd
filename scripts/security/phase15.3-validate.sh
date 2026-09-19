#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-runtime/evidence/phase-15.3}"

required=(
  preflight.json
  red-team-matrix.json
  authorization-boundary.json
  secret-safety.json
  data-isolation.json
)

for file in "${required[@]}"; do
  test -f "$DIR/$file" || { echo "NOT_EXECUTED: missing $DIR/$file"; exit 2; }
done

if grep -RniE 'password|api[_-]?key|encryption[_-]?key|authorization: Bearer|cvv|pan|card_number' "$DIR"; then
  echo "FAIL: sensitive data detected in security evidence."
  exit 1
fi

if grep -Rni '"status"[[:space:]]*:[[:space:]]*"PASS"' "$DIR/red-team-matrix.json" >/dev/null 2>&1; then
  echo "NOTE: individual PASS entries require live evidence review."
fi

echo "PASS: security evidence structure and secret-safety checks."
