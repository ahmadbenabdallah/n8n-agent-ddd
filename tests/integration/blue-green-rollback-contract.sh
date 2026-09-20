#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase15.7-blue-green-rollback.md"
for f in   spec/releases/phase-15.7-blue-green-rollback-execution.yaml   scripts/deployment/preflight.sh   scripts/deployment/blue-baseline.sh   scripts/deployment/deploy-green.sh   scripts/deployment/switch-and-rollback.sh   scripts/deployment/validate-evidence.sh
do
  test -f "$ROOT/$f"
done
for f in   scripts/deployment/preflight.sh   scripts/deployment/blue-baseline.sh   scripts/deployment/deploy-green.sh   scripts/deployment/switch-and-rollback.sh   scripts/deployment/validate-evidence.sh
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
