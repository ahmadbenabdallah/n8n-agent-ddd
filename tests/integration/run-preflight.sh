#!/usr/bin/env bash
set -euo pipefail
bash tests/integration/preflight.sh
echo "Phase 14 runtime is reachable; full certification still requires the complete live test suite."
