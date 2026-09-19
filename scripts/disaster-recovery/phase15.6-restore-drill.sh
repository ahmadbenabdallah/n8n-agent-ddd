#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_LIVE_DR:=}"
: "${RESTORE_TARGET_ISOLATED:=}"
: "${CONFIRM_DR:=}"
: "${RESTORE_TARGET_ID:=}"

[[ "$ALLOW_LIVE_DR" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_DR=YES required"; exit 2; }
[[ "$RESTORE_TARGET_ISOLATED" == "YES" ]] || { echo "BLOCKED: isolated target required"; exit 2; }
[[ "$CONFIRM_DR" == "YES" ]] || { echo "BLOCKED: CONFIRM_DR=YES required"; exit 2; }
[[ -n "$RESTORE_TARGET_ID" ]] || { echo "BLOCKED: RESTORE_TARGET_ID required"; exit 2; }

echo "Restore drill target: $RESTORE_TARGET_ID"
echo "Required operator actions:"
echo "  1. Restore PostgreSQL backup into the isolated target."
echo "  2. Restore n8n persistent state using the provider-specific snapshot/volume mechanism."
echo "  3. Inject the same persistent N8N_ENCRYPTION_KEY without printing it."
echo "  4. Start the restored runtime."
echo "  5. Continue with phase15.6-verify-restore.sh."
echo "No production restore is permitted."
