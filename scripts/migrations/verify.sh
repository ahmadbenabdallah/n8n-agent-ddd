#!/usr/bin/env bash
set -euo pipefail

: "${DATABASE_URL:?DATABASE_URL is required}"

command -v psql >/dev/null 2>&1 || {
  echo "ERROR: psql is required"
  exit 1
}

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "select current_database();" >/dev/null
echo "PASS: database verification command completed"
echo "Further schema/domain verification must use the release-specific checks."
