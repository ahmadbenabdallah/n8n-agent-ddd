#!/usr/bin/env bash
set -euo pipefail

echo "Phase 11 production preflight"
echo "Checking repository invariants..."

test -f agent-manifest.yaml
test -f spec/releases/phase-11-production-deployment.yaml
test -f spec/architecture/production-topology.yaml
test -f spec/architecture/production-secrets.yaml
test -f spec/architecture/production-deployment.yaml
test -f spec/architecture/production-rollback.yaml
test -d runtime/n8n/workflows

count="$(find runtime/n8n/workflows -maxdepth 1 -name 'WF-*.json' | wc -l | tr -d ' ')"
test "$count" = "21"

if grep -RInE '(sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|password[[:space:]]*[:=])'   --exclude-dir=.git --exclude='*.lock' . >/tmp/n8n-agent-ddd-secret-scan.txt 2>/dev/null; then
  echo "Potential secret-like material detected:"
  cat /tmp/n8n-agent-ddd-secret-scan.txt
  exit 1
fi

echo "PASS: Phase 11 repository preflight"
