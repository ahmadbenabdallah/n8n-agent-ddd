#!/usr/bin/env bash
set -euo pipefail

: "${CERTIFICATION_STATE:=}"
: "${PRODUCTION_APPROVAL:=}"
: "${PRODUCTION_PREFLIGHT:=}"

[[ "$CERTIFICATION_STATE" == "CERTIFIED" ]] || { echo "BLOCKED: Phase 15.9 certification must be CERTIFIED"; exit 3; }
[[ "$PRODUCTION_PREFLIGHT" == "PASS" ]] || { echo "BLOCKED: production preflight not PASS"; exit 3; }
[[ "$PRODUCTION_APPROVAL" == "APPROVED" ]] || { echo "BLOCKED: explicit production approval required"; exit 3; }

echo "Production gate conditions satisfied."
echo "This gate does not itself switch production traffic."
