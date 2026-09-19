#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:?environment required}"
TIMEOUT="${DRAIN_TIMEOUT_SECONDS:-300}"

echo "Draining $ENVIRONMENT for up to ${TIMEOUT}s."
echo "Deployment adapter must wait for active executions to reach safe zero."
