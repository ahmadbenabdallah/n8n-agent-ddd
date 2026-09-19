#!/usr/bin/env bash
set -euo pipefail

: "${N8N_VERSION:=}"
: "${DATABASE_PROVIDER:=}"
: "${N8N_BASE_URL:=}"
: "${N8N_PROJECT_NAME:=}"

[[ -n "$N8N_VERSION" ]] || { echo "MISSING: N8N_VERSION"; exit 2; }
[[ "$DATABASE_PROVIDER" == "postgres" ]] || { echo "BLOCKED: DATABASE_PROVIDER must be postgres"; exit 2; }
[[ -n "$N8N_BASE_URL" ]] || { echo "MISSING: N8N_BASE_URL"; exit 2; }
[[ -n "$N8N_PROJECT_NAME" ]] || { echo "MISSING: N8N_PROJECT_NAME"; exit 2; }

echo "Runtime configuration shape: PASS"
echo "Secrets are intentionally not printed."
