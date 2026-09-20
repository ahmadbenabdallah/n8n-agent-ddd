#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_LIVE_DR:=}"
: "${RESTORE_TARGET_ISOLATED:=}"
: "${CONFIRM_DR:=}"
: "${RESTORED_DB_URL:=}"

[[ "$ALLOW_LIVE_DR" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_DR=YES required"; exit 2; }
[[ "$RESTORE_TARGET_ISOLATED" == "YES" ]] || { echo "BLOCKED: isolated target required"; exit 2; }
[[ "$CONFIRM_DR" == "YES" ]] || { echo "BLOCKED: CONFIRM_DR=YES required"; exit 2; }

echo "Verification checklist:"
echo "  - restored runtime health"
echo "  - PostgreSQL connectivity"
echo "  - schema/version"
echo "  - n8n project binding"
echo "  - canonical WF-00..WF-20 inventory"
echo "  - synthetic durable-state marker"
echo "  - reconciliation"
echo "  - smoke tests"
echo "  - measured RPO/RTO"
echo
echo "RESTORED_DB_URL is intentionally not printed."
[[ -n "$RESTORED_DB_URL" ]] || echo "NOTE: RESTORED_DB_URL not set; provider/runtime-specific verification remains required."
echo "No PASS is asserted by this scaffold."
