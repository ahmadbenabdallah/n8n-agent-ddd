#!/usr/bin/env bash
set -euo pipefail

BACKUP="${1:?Usage: verify-postgres-backup.sh <backup-file>}"
CHECKSUM="${BACKUP}.sha256"

test -f "$BACKUP" || { echo "ERROR: backup not found"; exit 1; }
test -f "$CHECKSUM" || { echo "ERROR: checksum not found"; exit 1; }

sha256sum --check "$CHECKSUM"

command -v pg_restore >/dev/null 2>&1 || {
  echo "ERROR: pg_restore is required"
  exit 1
}

pg_restore --list "$BACKUP" >/dev/null

echo "Backup verification passed: $BACKUP"
