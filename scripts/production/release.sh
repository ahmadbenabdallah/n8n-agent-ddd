#!/usr/bin/env bash
set -euo pipefail

RELEASE="${1:?release version required}"
SLOT="${2:-green}"

echo "=== Production release ==="
echo "release=$RELEASE"
echo "slot=$SLOT"

bash scripts/production/preflight.sh
bash scripts/readiness/run-gates.sh

echo "Checking required Phase 10 staging status..."
python3 scripts/production/check-certification.py

echo "Deploying $SLOT..."
bash scripts/production/deploy-green.sh production "$RELEASE"

echo "Running health check..."
bash scripts/production/health-check.sh

echo "Running smoke test..."
bash scripts/production/smoke-test.sh

echo "Release prepared. Explicit approval is required before traffic switch."
