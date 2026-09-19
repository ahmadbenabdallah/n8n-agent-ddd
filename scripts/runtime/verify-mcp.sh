#!/usr/bin/env bash
set -euo pipefail
: "${N8N_MCP_URL:?N8N_MCP_URL required}"
curl -fsS --max-time 10 "$N8N_MCP_URL" >/dev/null || {
  echo "MCP endpoint not reachable. Enable Instance-level MCP and inject authenticated client configuration." >&2
  exit 1
}
echo "MCP endpoint reachable"
