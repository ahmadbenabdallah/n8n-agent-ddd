#!/usr/bin/env bash
set -euo pipefail
: "${N8N_BASE_URL:?N8N_BASE_URL required}"
: "${N8N_API_KEY:?N8N_API_KEY required}"
n8n_api() {
  local method="$1" path="$2" body="${3:-}"
  if [[ -n "$body" ]]; then
    curl -fsS -X "$method" -H "X-N8N-API-KEY: $N8N_API_KEY" -H "Content-Type: application/json" "$N8N_BASE_URL/api/v1$path" -d "$body"
  else
    curl -fsS -X "$method" -H "X-N8N-API-KEY: $N8N_API_KEY" "$N8N_BASE_URL/api/v1$path"
  fi
}
