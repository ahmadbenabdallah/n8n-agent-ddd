#!/usr/bin/env bash
set -euo pipefail

test -f spec/architecture/database-production-migration.yaml
test -f spec/architecture/backup-restore.yaml
test -f spec/architecture/blue-green-state.yaml
test -x scripts/production/db-migrate.sh
test -x scripts/production/db-backup.sh
test -x scripts/production/db-restore-verify.sh

echo "PASS: database production migration contract"
