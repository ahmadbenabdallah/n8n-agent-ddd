#!/usr/bin/env bash
set -euo pipefail
test -f spec/security/tailscale-zero-trust.yaml
test -f spec/security/external-egress-policy.yaml
test -f spec/deployment/tailscale-runtime.yaml
test -f infrastructure/security/tailscale/README.md
grep -q 'public_ingress: false' spec/security/tailscale-zero-trust.yaml
grep -q 'default: deny' spec/security/external-egress-policy.yaml
echo "PHASE13 TAILSCALE SECURITY PASS"
