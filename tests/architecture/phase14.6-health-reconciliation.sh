#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/runtime-health.md"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/reconciliation.md"
cd "$ROOT"

required=(
  "spec/runtime/health-reconciliation.yaml"
  "spec/releases/phase-14.6-health-reconciliation.yaml"
  "scripts/operations/runtime-health.sh"
  "scripts/operations/reconciliation-status.sh"
  "scripts/operations/drift-policy-check.sh"
  "scripts/operations/self-healing-policy-check.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/operations/runtime-health.sh \
  scripts/operations/reconciliation-status.sh \
  scripts/operations/drift-policy-check.sh \
  scripts/operations/self-healing-policy-check.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q "observe_before_act" spec/runtime/health-reconciliation.yaml
grep -q "reconciliation_precedes_retry" spec/runtime/health-reconciliation.yaml
grep -q "bypass_wf10" spec/runtime/health-reconciliation.yaml
grep -q "human_ownership_blocks_conflicting_automation" spec/runtime/health-reconciliation.yaml
grep -q "live_self_healing: NOT_EXECUTED" spec/releases/phase-14.6-health-reconciliation.yaml

echo "PASS: Phase 14.6 architecture/contract checks"
echo "NOTE: live health/reconciliation/self-healing evidence remains NOT EXECUTED."
