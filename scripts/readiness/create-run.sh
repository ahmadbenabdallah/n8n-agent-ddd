#!/usr/bin/env bash
set -euo pipefail

RUN_ID="${1:-$(date -u +%Y%m%dT%H%M%SZ)}"
ROOT="runtime/evidence/phase-10/runs/${RUN_ID}"
mkdir -p "${ROOT}"

cat > "${ROOT}/run-manifest.json" <<EOF
{
  "run_id": "${RUN_ID}",
  "phase": 10,
  "release": "0.10.0",
  "environment": "staging",
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "synthetic_data_required": true,
  "production_credentials_allowed": false
}
EOF

echo "${ROOT}"
