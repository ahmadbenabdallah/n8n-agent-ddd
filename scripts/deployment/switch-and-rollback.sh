#!/usr/bin/env bash
set -euo pipefail
: "${ALLOW_LIVE_BG:=}"
: "${CONFIRM_BG:=}"
: "${ROLLBACK_CONFIRM:=}"
[[ "$ALLOW_LIVE_BG" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_BG=YES"; exit 2; }
[[ "$CONFIRM_BG" == "YES" ]] || { echo "BLOCKED: CONFIRM_BG=YES"; exit 2; }
[[ "$ROLLBACK_CONFIRM" == "YES" ]] || { echo "BLOCKED: ROLLBACK_CONFIRM=YES"; exit 2; }
echo "Controlled rollback drill authorized for staging."
echo "Operator must switch to green, capture evidence, trigger rollback, switch to blue, drain green, and verify blue."
echo "Provider-specific traffic control is intentionally not hard-coded."
