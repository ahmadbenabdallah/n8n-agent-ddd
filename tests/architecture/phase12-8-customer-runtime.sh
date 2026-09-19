#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
"$ROOT/scripts/configuration/validate-runtime-surface.sh"
# Protected commerce/security workflows must remain platform-owned.
for wf in WF-01 WF-10 WF-15 WF-20; do
  grep -q "$wf" "$ROOT/spec/customization/ownership-and-upgrade.yaml"
done
# Raw deployment secrets must not be an end-user configuration surface.
grep -q 'raw_env_exposure: false' "$ROOT/spec/runtime/customer-runtime-surface.yaml"
# Durable configuration and extension state must have migrations.
grep -q 'CREATE TABLE IF NOT EXISTS customer_configurations' "$ROOT/platform/state/db/migrations/0002_customer_runtime_configuration.sql"
grep -q 'CREATE TABLE IF NOT EXISTS customer_extensions' "$ROOT/platform/state/db/migrations/0002_customer_runtime_configuration.sql"
grep -q 'CREATE TABLE IF NOT EXISTS configuration_changes' "$ROOT/platform/state/db/migrations/0002_customer_runtime_configuration.sql"
echo 'PHASE 12.8 CUSTOMER RUNTIME TEST PASS'
