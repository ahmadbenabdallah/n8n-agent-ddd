#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ENV_FILE="$ROOT/.env.local"

if [[ -f "$ENV_FILE" ]]; then
  echo "[env] .env.local already exists"
  exit 0
fi

cat > "$ENV_FILE" <<'EOF'
APP_ENV=local
NODE_ENV=development
POSTGRES_PASSWORD=change-me-local-only
N8N_PORT=5678
N8N_HOST=localhost
N8N_BASE_URL=http://localhost:5678
N8N_API_KEY=
GENERIC_TIMEZONE=Africa/Tunis
N8N_IMAGE=docker.n8n.io/n8nio/n8n:2.39.8
EOF

echo "[env] created .env.local"
echo "[env] IMPORTANT: replace POSTGRES_PASSWORD and configure N8N_API_KEY if MCP/API integration requires it."
