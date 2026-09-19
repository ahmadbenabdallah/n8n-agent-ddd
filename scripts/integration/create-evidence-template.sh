#!/usr/bin/env bash
set -euo pipefail

DIR="${EVIDENCE_DIR:-runtime/evidence/phase-15.0}"
mkdir -p "$DIR"

cat > "$DIR/runtime-manifest.json" <<EOF
{
  "phase": "15.0",
  "status": "NOT_EXECUTED",
  "environment": "${ENVIRONMENT:-staging}",
  "release_version": "${RELEASE_VERSION:-unknown}",
  "n8n_version": "${N8N_VERSION:-unknown}",
  "database_schema_version": "${DATABASE_SCHEMA_VERSION:-unknown}"
}
EOF

for f in project-binding workflow-inventory smoke-test; do
  printf '%s\n' '{"status":"NOT_EXECUTED"}' > "$DIR/$f.json"
done

printf '%s\n' '{"status":"NOT_EXECUTED","gates":[]}' > "$DIR/evidence-summary.json"
printf '%s\n' '{"status":"NOT_EXECUTED"}' > "$DIR/preflight.json"
printf '%s\n' '{"status":"NOT_EXECUTED"}' > "$DIR/n8n-readiness.json"
printf '%s\n' '{"status":"NOT_EXECUTED"}' > "$DIR/postgres-readiness.json"

echo "Created non-certifying Phase 15.0 evidence templates."
