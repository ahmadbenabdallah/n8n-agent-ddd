#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOMAIN="${1:-}"
if [[ -z "$DOMAIN" ]]; then
  echo "Usage: validate-domain-pack.sh <domain-path>"
  exit 2
fi
for f in domain.yaml domain-project.yaml; do
  test -f "$ROOT/$DOMAIN/$f" || { echo "MISSING: $DOMAIN/$f"; exit 1; }
done
for d in business entities aggregates value-objects commands events policies projections workflows knowledge adapters tests; do
  test -d "$ROOT/$DOMAIN/$d" || { echo "MISSING: $DOMAIN/$d"; exit 1; }
done
echo "Domain pack structure is valid."
