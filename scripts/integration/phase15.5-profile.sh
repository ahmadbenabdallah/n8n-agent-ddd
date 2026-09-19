#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.5}"
: "${LOAD_PROFILE:=baseline}"
: "${CONCURRENCY:=1}"
: "${DURATION_SECONDS:=30}"

mkdir -p "$EVIDENCE_DIR"

case "$LOAD_PROFILE" in
  baseline|steady_state|burst|saturation|recovery) ;;
  *) echo "ERROR: unsupported LOAD_PROFILE"; exit 1 ;;
esac

cat > "$EVIDENCE_DIR/load-profile.json" <<EOF
{
  "status": "NOT_EXECUTED",
  "profile": "${LOAD_PROFILE}",
  "concurrency": ${CONCURRENCY},
  "duration_seconds": ${DURATION_SECONDS},
  "production": false,
  "real_payment": false,
  "real_customer_traffic": false
}
EOF

echo "Created non-certifying load profile: ${LOAD_PROFILE}"
