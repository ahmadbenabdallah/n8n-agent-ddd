#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
for f in   spec/releases/phase-15.7-blue-green-rollback-execution.yaml   docs/operations/phase15.7-blue-green-rollback.md   scripts/deployment/phase15.7-preflight.sh   scripts/deployment/phase15.7-blue-baseline.sh   scripts/deployment/phase15.7-deploy-green.sh   scripts/deployment/phase15.7-switch-and-rollback.sh   scripts/deployment/phase15.7-validate-evidence.sh
do
  test -f "$ROOT/$f"
done
for f in   scripts/deployment/phase15.7-preflight.sh   scripts/deployment/phase15.7-blue-baseline.sh   scripts/deployment/phase15.7-deploy-green.sh   scripts/deployment/phase15.7-switch-and-rollback.sh   scripts/deployment/phase15.7-validate-evidence.sh
do
  bash -n "$ROOT/$f"
done
grep -q 'production_execution: false' "$ROOT/spec/releases/phase-15.7-blue-green-rollback-execution.yaml"
grep -q 'database_backup_required: true' "$ROOT/spec/releases/phase-15.7-blue-green-rollback-execution.yaml"
grep -q 'BG:' "$ROOT/spec/releases/phase-15.7-blue-green-rollback-execution.yaml"
grep -q 'ROLLBACK:' "$ROOT/spec/releases/phase-15.7-blue-green-rollback-execution.yaml"
grep -q 'status: "NOT_EXECUTED"' "$ROOT/spec/releases/phase-15.7-blue-green-rollback-execution.yaml"
echo "Phase 15.7 contract: PASS"
echo "Repository contract only; no live deployment evidence is claimed."
