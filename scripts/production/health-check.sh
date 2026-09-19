#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:?BASE_URL is required}"

curl --fail --silent --show-error "$BASE_URL/healthz" >/dev/null
echo "PASS: health endpoint"
