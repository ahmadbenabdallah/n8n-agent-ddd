#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

test -f "$ROOT/spec/releases/phase-15.6-backup-restore-execution.yaml"
[ ! -d "${ROOT:-.}/docs" ] || test -f "$ROOT/docs/operations/phase15.6-backup-restore.md"

for f in   scripts/disaster-recovery/preflight.sh   scripts/disaster-recovery/create-backup.sh   scripts/disaster-recovery/restore-drill.sh   scripts/disaster-recovery/verify-restore.sh   scripts/disaster-recovery/validate-evidence.sh
do
  test -f "$ROOT/$f"
  bash -n "$ROOT/$f"
done

grep -q 'production_restore: false' "$ROOT/spec/releases/phase-15.6-backup-restore-execution.yaml"
grep -q 'isolated_restore_required: true' "$ROOT/spec/releases/phase-15.6-backup-restore-execution.yaml"
grep -q 'same_n8n_encryption_key_required: true' "$ROOT/spec/releases/phase-15.6-backup-restore-execution.yaml"
grep -q 'status: "NOT_EXECUTED"' "$ROOT/spec/releases/phase-15.6-backup-restore-execution.yaml"

echo "Phase 15.6 contract: PASS"
echo "This is a repository contract check, not live DR evidence."
