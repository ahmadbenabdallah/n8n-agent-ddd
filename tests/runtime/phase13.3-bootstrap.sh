#!/usr/bin/env bash
set -euo pipefail
test -f scripts/runtime/n8n-api.sh
test -f scripts/runtime/initialize-project.sh
test -f spec/runtime/project-binding.yaml
echo "PHASE 13.3 BOOTSTRAP FOUNDATION PASS"
