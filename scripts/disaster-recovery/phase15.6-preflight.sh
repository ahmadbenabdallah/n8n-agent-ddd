#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_LIVE_DR:=}"
: "${RESTORE_TARGET_ISOLATED:=}"
: "${CONFIRM_DR:=}"

[[ "$ALLOW_LIVE_DR" == "YES" ]] || { echo "BLOCKED: set ALLOW_LIVE_DR=YES"; exit 2; }
[[ "$RESTORE_TARGET_ISOLATED" == "YES" ]] || { echo "BLOCKED: restore target must be isolated"; exit 2; }
[[ "$CONFIRM_DR" == "YES" ]] || { echo "BLOCKED: set CONFIRM_DR=YES"; exit 2; }

for cmd in date sha256sum; do
  command -v "$cmd" >/dev/null || { echo "MISSING: $cmd"; exit 2; }
done

echo "DR preflight contract: PASS"
echo "Execution remains NOT_EXECUTED until live staging evidence is captured."
