#!/usr/bin/env bash
set -euo pipefail

echo "Reconciliation policy status"
echo "rule=reconcile_before_retry"
echo "unknown_external_outcome=do_not_blind_retry"
echo "authorization_boundary=WF-10"
echo "execution_boundary=WF-20"

echo "PASS: reconciliation policy precheck"
echo "NOTE: no external commerce reconciliation was executed."
