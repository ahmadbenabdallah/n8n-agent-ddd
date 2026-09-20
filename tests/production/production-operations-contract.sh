#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase16-production-operationalization.md"

for f in   spec/releases/phase-16.0-production-operationalization.yaml   spec/releases/phase-16.0-gates.yaml   spec/deployment/phase-16-production-operationalization.yaml   scripts/production/operations-preflight.sh   scripts/production/runtime-doctor.sh   scripts/production/sync-plan.sh   scripts/production/evidence-runner.sh   scripts/production/production-gate.sh   scripts/production/status.sh
do
  test -f "$ROOT/$f"
done

for f in scripts/production/*.sh; do
  bash -n "$ROOT/$f"
done

grep -q 'production_execution: false' "$ROOT/spec/releases/phase-16.0-production-operationalization.yaml"
grep -q 'Production deployment is blocked until 0.15 certification is genuinely CERTIFIED.' "$ROOT/spec/releases/phase-16.0-production-operationalization.yaml"
grep -q 'production_switch_requires_explicit_approval: true' "$ROOT/spec/releases/phase-16.0-production-operationalization.yaml"
grep -q 'STAGING:' "$ROOT/spec/releases/phase-16.0-gates.yaml"
grep -q 'CERTIFICATION:' "$ROOT/spec/releases/phase-16.0-gates.yaml"

echo "Phase 16.0 contract: PASS"
echo "Operational contract only; no live runtime evidence is claimed."
