#!/usr/bin/env bash
set -euo pipefail
: "${ALLOW_LIVE_BG:=}"
: "${CONFIRM_BG:=}"
: "${BASELINE_DIR:=runtime/evidence/phase-15.7/blue-baseline}"
[[ "$ALLOW_LIVE_BG" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_BG=YES"; exit 2; }
[[ "$CONFIRM_BG" == "YES" ]] || { echo "BLOCKED: CONFIRM_BG=YES"; exit 2; }
mkdir -p "$BASELINE_DIR"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
cat > "$BASELINE_DIR/$stamp.txt" <<EOF
environment=staging
runtime_color=blue
captured_at=$stamp
release=TO_BE_CAPTURED
schema_version=TO_BE_CAPTURED
workflow_inventory=TO_BE_CAPTURED
health=TO_BE_CAPTURED
smoke=TO_BE_CAPTURED
EOF
echo "Blue baseline evidence placeholder created: $BASELINE_DIR/$stamp.txt"
