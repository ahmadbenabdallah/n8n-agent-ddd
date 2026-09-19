#!/usr/bin/env bash
set -euo pipefail

BACKUP="${1:?Usage: restore-postgres-backup.sh <backup-file>}"
: "${DATABASE_URL:?DATABASE_URL is required}"
: "${CONFIRM_RESTORE:?Set CONFIRM_RESTORE=YES to execute a restore}"

if [[ "$CONFIRM_RESTORE" != "YES" ]]; then
  echo "ERROR: restore blocked. Set CONFIRM_RESTORE=YES explicitly."
  exit 1
fi

test -f "$BACKUP" || { echo "ERROR: backup not found"; exit 1; }

command -v pg_restore >/dev/null 2>&1 || {
  echo "ERROR: pg_restore is required"
  exit 1
}

echo "WARNING: restoring into DATABASE_URL."
echo "The target must be an isolated/recovery database unless an approved"
echo "production restore procedure explicitly says otherwise."

pg_restore \
  --clean \
  --if-exists \
  --no-owner \
  --no-privileges \
  --dbname="$DATABASE_URL" \
  "$BACKUP"

echo "PostgreSQL restore command completed."
echo "Run application readiness, workflow verification, and reconciliation before traffic."
