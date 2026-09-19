#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:?action required}"
ATTEMPT="${2:-0}"

case "$ACTION" in
  restart_disposable_worker|retry_transient_internal_operation|clear_stale_runtime_lock|reschedule_reconciliation)
    ;;
  *)
    echo "DENIED: action is outside autonomous self-healing policy"
    exit 2
    ;;
esac

if [ "$ATTEMPT" -ge 3 ]; then
  echo "DENIED: self-healing attempt limit reached"
  exit 2
fi

echo "AUTHORIZED bounded self-healing action: $ACTION attempt=$ATTEMPT"
