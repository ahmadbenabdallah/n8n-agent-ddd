#!/usr/bin/env bash
set -euo pipefail
provider="${1:-local}"
case "$provider" in
  local) echo "provider=local; use infrastructure/docker/docker-compose.local.yml" ;;
  vps) echo "provider=vps; use infrastructure/docker/docker-compose.n8n-only.yml" ;;
  railway) echo "provider=railway; use infrastructure/providers/railway/" ;;
  vps_all) echo "provider=vps_all; use the full Docker runtime profile" ;;
  *) echo "Unknown provider: $provider" >&2; exit 2 ;;
esac
echo "Secrets must be injected by the deployment environment; no secrets are rendered."
