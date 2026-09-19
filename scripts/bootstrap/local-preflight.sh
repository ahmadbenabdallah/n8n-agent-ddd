#!/usr/bin/env bash
set -euo pipefail

command -v docker >/dev/null || { echo "ERROR: docker is required"; exit 1; }

if [[ "${NODE_ENV:-development}" == "production" || "${APP_ENV:-local}" != "local" ]]; then
  echo "ERROR: local bootstrap requires APP_ENV=local and must not run in production"
  exit 1
fi

echo "OK: docker available"
echo "OK: local environment guard passed"
