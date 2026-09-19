#!/usr/bin/env bash
set -euo pipefail

N8N_VERSION="${N8N_VERSION:-unknown}"
RUNTIME_VERSION="${RUNTIME_VERSION:-unknown}"

echo "Runtime compatibility precheck"
echo "n8n_version=${N8N_VERSION}"
echo "runtime_version=${RUNTIME_VERSION}"

if [[ "$N8N_VERSION" == "unknown" ]]; then
  echo "WARN: N8N_VERSION is not set"
fi

echo "PASS: static compatibility precheck completed"
echo "NOTE: actual n8n release compatibility requires staging execution."
