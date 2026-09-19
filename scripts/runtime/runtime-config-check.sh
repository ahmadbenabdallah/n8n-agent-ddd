#!/usr/bin/env bash
set -euo pipefail

mode="${DEPLOYMENT_MODE:-${1:-local_all}}"
required=(DEPLOYMENT_MODE ENVIRONMENT N8N_IMAGE GENERIC_TIMEZONE)

fail=0
for key in "${required[@]}"; do
  if [[ -z "${!key:-}" ]]; then
    echo "FAIL missing $key"
    fail=1
  fi
done

case "$mode" in
  local_all)
    for key in POSTGRES_PASSWORD N8N_ENCRYPTION_KEY; do
      [[ -n "${!key:-}" ]] || { echo "FAIL missing $key"; fail=1; }
    done
    ;;
  n8n_remote|vps_all|managed_provider)
    for key in N8N_BASE_URL WEBHOOK_URL N8N_ENCRYPTION_KEY; do
      [[ -n "${!key:-}" ]] || { echo "FAIL missing $key"; fail=1; }
    done
    ;;
  *)
    echo "FAIL unsupported DEPLOYMENT_MODE=$mode"
    fail=1
    ;;
esac

if [[ "$fail" -ne 0 ]]; then
  exit 1
fi

echo "RUNTIME CONFIG PASS: $mode"
