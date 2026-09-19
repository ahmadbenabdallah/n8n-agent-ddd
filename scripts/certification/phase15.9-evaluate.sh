#!/usr/bin/env bash
set -euo pipefail
MANIFEST="${MANIFEST:-runtime/evidence/phase-15.9/evidence-index.yaml}"
DECISION="${DECISION:-runtime/evidence/phase-15.9/certification-decision.yaml}"
[[ -f "$MANIFEST" ]] || { echo "BLOCKED: evidence index missing"; exit 2; }
mkdir -p "$(dirname "$DECISION")"
if grep -Eq '^[[:space:]]+[A-Z_]+: (NOT_EXECUTED|FAIL)$' "$MANIFEST"; then
  state="NOT_READY"
else
  state="READY_FOR_APPROVAL"
fi
printf 'phase: "0.15.9"
environment: "staging"
state: "%s"
production_traffic_switch: "EXPLICIT_APPROVAL_REQUIRED"
generated_at: "%s"
'   "$state" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$DECISION"
echo "Certification state: $state"
echo "This script does not grant production approval."
