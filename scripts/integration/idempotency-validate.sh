#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-runtime/evidence/phase-15.4}"

required=(
  preflight.json
  idempotency-matrix.json
  reconciliation-matrix.json
  mutation-ledger.json
  restart-persistence.json
)

for file in "${required[@]}"; do
  test -f "$DIR/$file" || { echo "NOT_EXECUTED: missing $DIR/$file"; exit 2; }
done

if grep -RniE 'password|api[_-]?key|encryption[_-]?key|authorization: Bearer|cvv|pan|card_number' "$DIR"; then
  echo "FAIL: sensitive data detected in idempotency/reconciliation evidence."
  exit 1
fi

echo "PASS: Phase 15.4 evidence structure and secret-safety checks."
