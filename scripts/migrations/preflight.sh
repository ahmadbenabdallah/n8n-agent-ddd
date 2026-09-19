#!/usr/bin/env bash
set -euo pipefail

: "${DATABASE_URL:?DATABASE_URL is required}"

command -v psql >/dev/null 2>&1 || {
  echo "ERROR: psql is required"
  exit 1
}

echo "Migration preflight"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "select current_database(), current_user, version();" >/dev/null
echo "PASS: database reachable"
echo "NOTE: verified backup and release approval must be checked by the deployment gate."
