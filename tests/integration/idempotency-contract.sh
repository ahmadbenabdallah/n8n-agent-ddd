#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase15.4-idempotency-reconciliation.md"
cd "$ROOT"

required=(
  "spec/releases/phase-15.4-idempotency-reconciliation.yaml"
  "scripts/integration/idempotency-preflight.sh"
  "scripts/integration/idempotency-matrix.sh"
  "scripts/integration/idempotency-validate.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/integration/idempotency-preflight.sh \
  scripts/integration/idempotency-matrix.sh \
  scripts/integration/idempotency-validate.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q 'reconcile_before_retry' spec/releases/phase-15.4-idempotency-reconciliation.yaml
grep -q 'reconciliation_does_not_authorize' spec/releases/phase-15.4-idempotency-reconciliation.yaml
grep -q 'one_business_mutation' spec/releases/phase-15.4-idempotency-reconciliation.yaml
grep -q 'live_idempotency: NOT_EXECUTED' spec/releases/phase-15.4-idempotency-reconciliation.yaml

echo "PASS: Phase 15.4 idempotency/reconciliation contract checks"
echo "NOTE: live idempotency/reconciliation remains NOT EXECUTED."
