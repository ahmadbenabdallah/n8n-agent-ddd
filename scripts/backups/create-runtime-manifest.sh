#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${BACKUP_DIR:-runtime/backups}"
mkdir -p "$OUT_DIR"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="${OUT_DIR}/runtime-${STAMP}.manifest"

cat > "$OUT" <<EOF
backup_id=runtime-${STAMP}
created_at=${STAMP}
release_version=${RELEASE_VERSION:-unknown}
runtime_version=${RUNTIME_VERSION:-unknown}
database_schema_version=${DATABASE_SCHEMA_VERSION:-unknown}
environment=${ENVIRONMENT:-unknown}
n8n_version=${N8N_VERSION:-unknown}
n8n_project_id=${N8N_PROJECT_ID:-unknown}
EOF

echo "Runtime manifest created: $OUT"
