#!/usr/bin/env bash
set -euo pipefail

echo "Reconciliation runner"
echo "1. identify UNKNOWN operations"
echo "2. query external source of truth"
echo "3. correlate idempotency/external references"
echo "4. classify verified execution state"
echo "5. audit resolution"
echo "6. escalate conflicts"
echo "Never blindly retry an unknown commerce mutation."
