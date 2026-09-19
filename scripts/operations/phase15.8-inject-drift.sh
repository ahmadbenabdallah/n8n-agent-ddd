#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_LIVE_DRIFT:=}"
: "${CONFIRM_SELF_HEAL:=}"
: "${DRIFT_CASE:=workflow_definition_drift}"
: "${EVIDENCE_DIR:=runtime/evidence/phase-15.8/drift}"

[[ "$ALLOW_LIVE_DRIFT" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_DRIFT=YES"; exit 2; }
[[ "$CONFIRM_SELF_HEAL" == "YES" ]] || { echo "BLOCKED: CONFIRM_SELF_HEAL=YES"; exit 2; }

case "$DRIFT_CASE" in
  workflow_definition_drift|workflow_activation_state_drift|runtime_configuration_drift|database_schema_drift_detection) ;;
  *) echo "BLOCKED: unsupported DRIFT_CASE=$DRIFT_CASE"; exit 2 ;;
esac

mkdir -p "$EVIDENCE_DIR"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
cat > "$EVIDENCE_DIR/$stamp.txt" <<EOF
case=$DRIFT_CASE
environment=staging
injected_at=$stamp
canonical_source=TO_BE_CAPTURED
observed_state=TO_BE_CAPTURED
EOF

echo "Controlled drift case prepared: $DRIFT_CASE"
echo "Provider/runtime-specific mutation must be performed by the staging operator."
echo "Do not inject irreversible or commerce-state drift."
