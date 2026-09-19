#!/usr/bin/env bash
set -euo pipefail
test -f runtime/mcp/connection-contract.yaml
test -f scripts/runtime/verify-mcp.sh
grep -q 'using-n8n-skills-official' runtime/mcp/connection-contract.yaml
echo "PHASE 13.4 MCP/SKILLS FOUNDATION PASS"
