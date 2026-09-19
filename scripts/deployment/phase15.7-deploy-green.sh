#!/usr/bin/env bash
set -euo pipefail
: "${ALLOW_LIVE_BG:=}"
: "${CONFIRM_BG:=}"
: "${GREEN_RELEASE:=}"
[[ "$ALLOW_LIVE_BG" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_BG=YES"; exit 2; }
[[ "$CONFIRM_BG" == "YES" ]] || { echo "BLOCKED: CONFIRM_BG=YES"; exit 2; }
[[ -n "$GREEN_RELEASE" ]] || { echo "BLOCKED: GREEN_RELEASE required"; exit 2; }
echo "Deploy green release: $GREEN_RELEASE"
echo "Required before traffic switch:"
echo "  - compatible expand migrations"
echo "  - green health check"
echo "  - green smoke tests"
echo "  - canonical 21-workflow inventory"
echo "No traffic switch is performed by this scaffold."
