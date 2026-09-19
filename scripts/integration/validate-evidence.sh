#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-runtime/evidence/phase-15.0}"

required=(
  runtime-manifest.json
  preflight.json
  n8n-readiness.json
  postgres-readiness.json
  project-binding.json
  workflow-inventory.json
  smoke-test.json
  evidence-summary.json
)

missing=0
for file in "${required[@]}"; do
  if [[ ! -f "$DIR/$file" ]]; then
    echo "MISSING: $DIR/$file"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "NOT_EXECUTED: evidence set incomplete."
  exit 2
fi

if grep -RniE 'password|api[_-]?key|encryption[_-]?key|authorization: Bearer|cvv|pan' "$DIR"; then
  echo "FAIL: potentially sensitive content detected in evidence."
  exit 1
fi

echo "PASS: evidence structure and basic secret-safety checks."
