#!/usr/bin/env bash
set -euo pipefail
test -f scripts/runtime/plan-21-sync.sh
count=$(find domains/tunisia-dtc/workflows -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
[[ "$count" == "21" ]]
echo "PHASE 13.5 21-WORKFLOW SYNC FOUNDATION PASS"
