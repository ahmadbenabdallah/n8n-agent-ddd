#!/usr/bin/env bash
set -euo pipefail

: "${HEAL_ACTION:=}"

case "$HEAL_ACTION" in
  restart_disposable_worker|bounded_transient_internal_retry|clear_stale_runtime_lock|reschedule_reconciliation)
    echo "Allowed operational action: $HEAL_ACTION"
    ;;
  authorize_commerce|change_price|change_stock|change_payment_status|bypass_WF-10|blind_retry_unknown_commerce_mutation|rotate_or_export_secrets)
    echo "FORBIDDEN self-healing action: $HEAL_ACTION"
    exit 3
    ;;
  *)
    echo "Unknown action; default deny: ${HEAL_ACTION:-<empty>}"
    exit 3
    ;;
esac

echo "Safety policy check: PASS"
