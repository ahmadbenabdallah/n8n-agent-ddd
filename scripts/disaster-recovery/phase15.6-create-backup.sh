#!/usr/bin/env bash
set -euo pipefail

: "${ALLOW_LIVE_DR:=}"
: "${RESTORE_TARGET_ISOLATED:=}"
: "${CONFIRM_DR:=}"
: "${BACKUP_DIR:=runtime/evidence/phase-15.6/backup}"

[[ "$ALLOW_LIVE_DR" == "YES" ]] || { echo "BLOCKED: ALLOW_LIVE_DR=YES required"; exit 2; }
[[ "$RESTORE_TARGET_ISOLATED" == "YES" ]] || { echo "BLOCKED: isolated target required"; exit 2; }
[[ "$CONFIRM_DR" == "YES" ]] || { echo "BLOCKED: CONFIRM_DR=YES required"; exit 2; }

mkdir -p "$BACKUP_DIR"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
manifest="$BACKUP_DIR/backup-$stamp.manifest"

cat > "$manifest" <<EOF
phase=0.15.6
backup_timestamp=$stamp
target=staging
restore_target=isolated
postgres_backup=PROVIDER_SPECIFIC
n8n_persistent_state=PROVIDER_SPECIFIC
checksum=TO_BE_CAPTURED
EOF

echo "Backup manifest created: $manifest"
echo "Provider-specific backup execution must be performed by the staging operator."
echo "No live backup is claimed by this script."
