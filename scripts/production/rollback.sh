#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:?rollback target required}"

echo "Rollback target: $TARGET"
echo "Before rollback:"
echo " - preserve audit evidence"
echo " - preserve idempotency records"
echo " - determine whether external commerce execution occurred"
echo " - reconcile unknown outcomes"
echo " - then switch traffic to the known-safe release"
