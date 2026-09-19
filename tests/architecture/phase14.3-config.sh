#!/usr/bin/env bash
set -euo pipefail
test -f spec/runtime/configuration-bootstrap.yaml
test -f spec/runtime/secrets-contract.yaml
test -f scripts/bootstrap/generate-local-env.sh
test -f scripts/bootstrap/validate-secrets.sh
grep -q 'never_commit_real_secret' spec/runtime/secrets-contract.yaml
grep -q 'postgresql' spec/runtime/configuration-bootstrap.yaml
echo "PHASE 14.3 CONFIG/SECRETS PASS"
