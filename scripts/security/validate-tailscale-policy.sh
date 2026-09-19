#!/usr/bin/env bash
set -euo pipefail
test -f spec/security/tailscale-zero-trust.yaml
test -f spec/security/external-egress-policy.yaml
test -f infrastructure/security/tailscale/grants.hujson.example
grep -q 'n8n_ui_is_private' spec/security/tailscale-zero-trust.yaml
grep -q 'default: deny' spec/security/external-egress-policy.yaml
grep -q 'tcp:5678' infrastructure/security/tailscale/grants.hujson.example
echo "TAILSCALE ZERO TRUST PASS"
