#!/usr/bin/env bash
set -euo pipefail
test -f spec/security/protected-workflow-policy.yaml
bash scripts/security/verify-protected-set.sh
