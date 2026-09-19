#!/usr/bin/env bash
set -euo pipefail
required=(N8N_BASE_URL N8N_ENCRYPTION_KEY DB_POSTGRESDB_HOST DB_POSTGRESDB_DATABASE DB_POSTGRESDB_USER DB_POSTGRESDB_PASSWORD)
for key in "${required[@]}"; do
  if [[ -z "${!key:-}" || "${!key:-}" == "CHANGE_ME" || "${!key:-}" == "SET_AS_SECRET" ]]; then
    echo "Missing runtime variable: $key" >&2
    exit 1
  fi
done
if [[ "${N8N_SECURE_COOKIE:-true}" != "true" ]]; then
  echo "Warning: N8N_SECURE_COOKIE is not true."
fi
echo "runtime-config PASS"
