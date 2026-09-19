#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

required=(
  "spec/runtime/backup-restore.yaml"
  "spec/releases/phase-14.4-backup-restore.yaml"
  "infrastructure/backups/README.md"
  "docs/operations/backup-restore.md"
  "scripts/backups/create-postgres-backup.sh"
  "scripts/backups/verify-postgres-backup.sh"
  "scripts/backups/restore-postgres-backup.sh"
  "scripts/backups/create-runtime-manifest.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/backups/create-postgres-backup.sh \
  scripts/backups/verify-postgres-backup.sh \
  scripts/backups/restore-postgres-backup.sh \
  scripts/backups/create-runtime-manifest.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q "live_backup: NOT_EXECUTED" spec/releases/phase-14.4-backup-restore.yaml
grep -q "live_restore: NOT_EXECUTED" spec/releases/phase-14.4-backup-restore.yaml
grep -q "secrets" spec/runtime/backup-restore.yaml
grep -q "reconcile" docs/operations/backup-restore.md

echo "PASS: Phase 14.4 architecture/contract checks"
echo "NOTE: live backup/restore and DR evidence remain NOT EXECUTED."
