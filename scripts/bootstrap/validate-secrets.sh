#!/usr/bin/env bash
set -euo pipefail
: "${N8N_ENCRYPTION_KEY:?N8N_ENCRYPTION_KEY required}"
: "${DB_POSTGRESDB_PASSWORD:?DB_POSTGRESDB_PASSWORD required}"
for value in "$N8N_ENCRYPTION_KEY" "$DB_POSTGRESDB_PASSWORD"; do
  [[ "$value" != "change-me-local" ]] || { echo "Placeholder secret detected" >&2; exit 1; }
  [[ "$value" != "CHANGE_ME" ]] || { echo "Placeholder secret detected" >&2; exit 1; }
done
echo "SECRET INPUT VALIDATION PASS"
