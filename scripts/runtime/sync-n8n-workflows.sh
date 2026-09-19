#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SOURCE="$ROOT/domains/tunisia-dtc/workflows"
MANIFEST="$ROOT/runtime/bootstrap/runtime-manifest.yaml"

if [[ ! -d "$SOURCE" ]]; then
  echo "ERROR: workflow source directory not found: $SOURCE"
  exit 1
fi

EXPECTED=21
FOUND="$(find "$SOURCE" -mindepth 1 -maxdepth 1 -type d -name 'WF-*' | wc -l | tr -d ' ')"

if [[ "$FOUND" != "$EXPECTED" ]]; then
  echo "ERROR: expected $EXPECTED workflow directories, found $FOUND"
  exit 1
fi

echo "[sync] validated desired-state source: $SOURCE"
echo "[sync] n8n synchronization adapter is intentionally explicit."

if [[ -z "${N8N_BASE_URL:-}" ]]; then
  echo "ERROR: N8N_BASE_URL is required for real synchronization."
  exit 2
fi

if [[ -z "${N8N_API_KEY:-}" ]]; then
  echo "ERROR: N8N_API_KEY is required for real synchronization."
  exit 2
fi

echo "[sync] n8n API credentials detected."
echo "[sync] NOTE: workflow import/update implementation remains a follow-up adapter."
echo "[sync] No workflows were mutated by this script."
