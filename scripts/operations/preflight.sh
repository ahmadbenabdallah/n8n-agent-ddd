#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_LIVE_DRIFT:=}"
: "${SELF_HEAL_TARGET_ISOLATED:=}"
: "${CONFIRM_SELF_HEAL:=}"

[[ "$ALLOW_LIVE_DRIFT" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_DRIFT=YES"; exit 2; }
[[ "$SELF_HEAL_TARGET_ISOLATED" == "YES" ]] || { echo "BLOCKED: isolated self-healing target required"; exit 2; }
[[ "$CONFIRM_SELF_HEAL" == "YES" ]] || { echo "BLOCKED: CONFIRM_SELF_HEAL=YES"; exit 2; }

for cmd in date sha256sum; do
  command -v "$cmd" >/dev/null || { echo "MISSING: $cmd"; exit 2; }
done

echo "Phase 15.8 preflight contract: PASS"
echo "Live drift/self-healing remains NOT_EXECUTED."
