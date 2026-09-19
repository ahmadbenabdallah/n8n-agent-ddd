#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-artifacts/backups}"
mkdir -p "$OUT"

if [ -z "${DATABASE_URL:-}" ]; then
  echo "BLOCKED: DATABASE_URL is not set."
  exit 2
fi

command -v pg_dump >/dev/null 2>&1 || {
  echo "BLOCKED: pg_dump is required for this backup adapter."
  exit 2
}

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
FILE="$OUT/postgres-$STAMP.dump"

echo "Creating PostgreSQL backup: $FILE"
pg_dump --format=custom --no-owner --file="$FILE" "$DATABASE_URL"

echo "Backup created: $FILE"
sha256sum "$FILE" > "$FILE.sha256"
