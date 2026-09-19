#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:?target environment required: blue|green}"

case "$TARGET" in
  blue|green) ;;
  *) echo "Invalid target"; exit 2 ;;
esac

echo "Traffic switch requested: $TARGET"
echo "Provider-specific routing must be configured by the deployment adapter."
echo "No implicit traffic switch is performed."
