#!/usr/bin/env bash
set -euo pipefail

: "${DOMAIN_ID:=tunisia-dtc}"
: "${WORKFLOW_ROOT:=domains/tunisia-dtc/workflows}"
: "${OUT:=runtime/evidence/phase-16/workflow-sync-plan.txt}"

mkdir -p "$(dirname "$OUT")"
: > "$OUT"

count=0
for n in $(seq -w 0 20); do
  key="WF-$n"
  if [[ -d "$WORKFLOW_ROOT/$key" ]]; then
    echo "$DOMAIN_ID/$key" >> "$OUT"
    count=$((count+1))
  fi
done

echo "domain=$DOMAIN_ID" >> "$OUT"
echo "workflow_count=$count" >> "$OUT"

if [[ "$count" -ne 21 ]]; then
  echo "BLOCKED: expected 21 workflow directories, found $count"
  exit 3
fi

echo "Workflow synchronization plan: PASS"
echo "Plan only; no n8n workflow mutation performed."
