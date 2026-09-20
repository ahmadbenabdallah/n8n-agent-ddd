#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-runtime/evidence/phase-15.2}"

required=(
  preflight.json
  scenario-results.json
  commerce-verification.json
  authorization-evidence.json
  audit-evidence.json
  evidence-summary.json
)

for file in "${required[@]}"; do
  test -f "$DIR/$file" || { echo "NOT_EXECUTED: missing $DIR/$file"; exit 2; }
done

if grep -RniE 'password|api[_-]?key|encryption[_-]?key|authorization: Bearer|cvv|pan|card_number' "$DIR"; then
  echo "FAIL: sensitive data detected in E2E evidence."
  exit 1
fi

echo "PASS: Phase 15.2 evidence structure and secret-safety checks."
