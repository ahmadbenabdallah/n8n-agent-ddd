#!/usr/bin/env bash
set -euo pipefail
echo "WARNING: this destroys local runtime state."
read -r -p "Type RESET to continue: " answer
[[ "$answer" == "RESET" ]] || exit 1
docker compose -f infrastructure/docker/docker-compose.local.yml down -v
echo "Local runtime volumes removed."
