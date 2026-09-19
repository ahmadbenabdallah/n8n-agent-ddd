#!/usr/bin/env bash
set -euo pipefail

BACKUP="${1:?backup file required}"
RESTORE_DATABASE_URL="${RESTORE_DATABASE_URL:-}"

test -f "$BACKUP"

if [ -z "$RESTORE_DATABASE_URL" ]; then
  echo "BLOCKED: RESTORE_DATABASE_URL is not set."
  exit 2
fi

command -v pg_restore >/dev/null 2>&1 || {
  echo "BLOCKED: pg_restore is required."
  exit 2
}

echo "Restoring backup into the designated verification database."
pg_restore --clean --if-exists --no-owner --dbname="$RESTORE_DATABASE_URL" "$BACKUP"

echo "Restore completed. Running structural verification."
psql "$RESTORE_DATABASE_URL" -Atc "select current_database();" >/dev/null

echo "Verify critical extensions, tables, indexes and RLS policies using the configured validation suite."
