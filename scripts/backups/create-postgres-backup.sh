#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${BACKUP_DIR:-runtime/backups}"
mkdir -p "$OUT_DIR"

: "${DATABASE_URL:?DATABASE_URL is required}"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="${OUT_DIR}/postgres-${STAMP}.dump"

command -v pg_dump >/dev/null 2>&1 || {
  echo "ERROR: pg_dump is required"
  exit 1
}

pg_dump \
  --format=custom \
  --no-owner \
  --no-privileges \
  --file="$OUT" \
  "$DATABASE_URL"

sha256sum "$OUT" > "${OUT}.sha256"

cat > "${OUT}.manifest" <<EOF
backup_id=postgres-${STAMP}
created_at=${STAMP}
type=postgresql-custom
artifact=$(basename "$OUT")
checksum=$(cut -d' ' -f1 "${OUT}.sha256")
EOF

echo "Backup created: $OUT"
