#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

required=(
  "spec/runtime/upgrade-migration.yaml"
  "spec/releases/phase-14.5-upgrade-migration.yaml"
  "docs/operations/upgrade-migration.md"
  "scripts/migrations/preflight.sh"
  "scripts/migrations/plan.sh"
  "scripts/migrations/apply.sh"
  "scripts/migrations/verify.sh"
  "scripts/upgrades/compatibility-check.sh"
  "scripts/upgrades/release-preflight.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/migrations/preflight.sh \
  scripts/migrations/plan.sh \
  scripts/migrations/apply.sh \
  scripts/migrations/verify.sh \
  scripts/upgrades/compatibility-check.sh \
  scripts/upgrades/release-preflight.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q "expand_before_contract" spec/runtime/upgrade-migration.yaml
grep -q "destructive_migrations: explicit_approval_required" spec/runtime/upgrade-migration.yaml
grep -q "live_rollback: NOT_EXECUTED" spec/releases/phase-14.5-upgrade-migration.yaml
grep -q "rollback" docs/operations/upgrade-migration.md

echo "PASS: Phase 14.5 architecture/contract checks"
echo "NOTE: live upgrade/migration/rollback evidence remains NOT EXECUTED."
