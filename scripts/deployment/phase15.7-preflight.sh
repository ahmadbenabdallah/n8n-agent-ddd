#!/usr/bin/env bash
set -euo pipefail
: "${ALLOW_LIVE_BG:=}"
: "${BLUE_GREEN_TARGET_ISOLATED:=}"
: "${CONFIRM_BG:=}"
[[ "$ALLOW_LIVE_BG" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_BG=YES"; exit 2; }
[[ "$BLUE_GREEN_TARGET_ISOLATED" == "YES" ]] || { echo "BLOCKED: isolated blue/green target required"; exit 2; }
[[ "$CONFIRM_BG" == "YES" ]] || { echo "BLOCKED: CONFIRM_BG=YES"; exit 2; }
for cmd in date sha256sum; do command -v "$cmd" >/dev/null || { echo "MISSING: $cmd"; exit 2; }; done
echo "Phase 15.7 preflight contract: PASS"
echo "Live execution remains NOT_EXECUTED."
