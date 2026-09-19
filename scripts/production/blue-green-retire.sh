#!/usr/bin/env bash
set -euo pipefail

SLOT="${1:?slot required}"
TIMEOUT="${DRAIN_TIMEOUT_SECONDS:-300}"

echo "Retiring slot: $SLOT"
echo "Drain timeout: ${TIMEOUT}s"
echo "Wait for active executions to reach safe zero."
echo "Do not terminate executions that may have unknown external outcomes."
