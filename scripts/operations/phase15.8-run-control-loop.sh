#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_LIVE_DRIFT:=}"
: "${SELF_HEAL_TARGET_ISOLATED:=}"
: "${CONFIRM_SELF_HEAL:=}"
: "${HEAL_ACTION:=}"

[[ "$ALLOW_LIVE_DRIFT" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_DRIFT=YES"; exit 2; }
[[ "$SELF_HEAL_TARGET_ISOLATED" == "YES" ]] || { echo "BLOCKED: isolated target required"; exit 2; }
[[ "$CONFIRM_SELF_HEAL" == "YES" ]] || { echo "BLOCKED: CONFIRM_SELF_HEAL=YES"; exit 2; }

case "$HEAL_ACTION" in
  restart_disposable_worker|bounded_transient_internal_retry|clear_stale_runtime_lock|reschedule_reconciliation) ;;
  *) echo "BLOCKED: forbidden or unsupported self-healing action"; exit 2 ;;
esac

echo "Control loop execution authorized for bounded operational action: $HEAL_ACTION"
echo "Required sequence:"
echo "  OBSERVE -> CLASSIFY -> DECIDE -> ACT -> VERIFY -> AUDIT -> LEARN"
echo "This scaffold does not directly mutate a provider runtime."
