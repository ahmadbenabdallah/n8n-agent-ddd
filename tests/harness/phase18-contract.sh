#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
files=(
  spec/releases/phase-18.0-agent-installable-platform.yaml
  spec/harness/installer-contract.yaml
  spec/harness/bootstrap-contract.yaml
  spec/harness/doctor-contract.yaml
  spec/harness/configuration-contract.yaml
  docs/agents/agent-installable-platform.md
  scripts/harness/install.sh
  scripts/harness/init.sh
  scripts/harness/doctor.sh
  scripts/harness/configure.sh
  scripts/harness/develop.sh
  scripts/harness/test.sh
  scripts/harness/security.sh
  scripts/harness/validate.sh
  scripts/harness/deploy.sh
)
for f in "${files[@]}"; do test -f "$ROOT/$f" || { echo "MISSING: $f"; exit 1; }; done
for f in scripts/harness/*.sh; do bash -n "$ROOT/$f"; done
grep -q 'harness_is_not_customer_runtime: true' "$ROOT/spec/releases/phase-18.0-agent-installable-platform.yaml"
grep -q 'coding_agents_must_not_ssh_directly_to_production: true' "$ROOT/spec/releases/phase-18.0-agent-installable-platform.yaml"
grep -q 'live_production_deployment: "NOT_EXECUTED"' "$ROOT/spec/releases/phase-18.0-agent-installable-platform.yaml"
echo "Phase 18 contract successful."
