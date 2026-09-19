#!/usr/bin/env bash
set -euo pipefail

echo "Self-healing safety policy"
echo "allowed=restart_disposable_worker,retry_transient_internal_operation,clear_stale_runtime_lock,reschedule_reconciliation"
echo "forbidden=authorize_commerce,change_price,change_stock,change_payment_status,bypass_wf10,blind_retry_unknown_external_mutation,rotate_or_export_secrets"
echo "max_attempts=3"
echo "cooldown=required"
echo "circuit_breaker=required"
echo "audit=required"
echo "human_override=required"

echo "PASS: self-healing safety policy"
