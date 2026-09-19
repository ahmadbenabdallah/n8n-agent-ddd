#!/usr/bin/env bash
set -euo pipefail

EVIDENCE_DIR="${EVIDENCE_DIR:-runtime/evidence/phase-15.6}"

required=(
  "backup"
  "restore"
  "verification"
  "rpo-rto"
)

for item in "${required[@]}"; do
  if [[ ! -e "$EVIDENCE_DIR/$item" ]]; then
    echo "MISSING evidence category: $item"
  fi
done

echo
echo "Evidence validation is structural only."
echo "DR/RPO/RTO remain NOT_EXECUTED unless sanitized runtime evidence is present."
