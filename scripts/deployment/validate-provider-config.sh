#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODE="${DEPLOYMENT_MODE:-local_all}"

case "$MODE" in
  local_all)
    FILE="$ROOT/infrastructure/environments/local/.env.example" ;;
  n8n_remote|vps_all|managed_provider)
    FILE="$ROOT/infrastructure/environments/remote-n8n/.env.example" ;;
  *)
    echo "FAIL unsupported mode: $MODE" >&2
    exit 1 ;;
esac

[[ -f "$FILE" ]] || { echo "FAIL missing profile $FILE" >&2; exit 1; }
grep -q '^DEPLOYMENT_MODE=' "$FILE"
grep -q '^N8N_IMAGE=' "$FILE"
grep -q '^N8N_ENCRYPTION_KEY=' "$FILE"

echo "PROVIDER CONFIG CONTRACT PASS: $MODE"
