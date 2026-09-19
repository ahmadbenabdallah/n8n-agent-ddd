#!/usr/bin/env bash
set -euo pipefail

COMMAND="${1:-status}"

case "$COMMAND" in
  init|doctor|install|configure|develop|plan|test|security|validate|deploy|upgrade|rollback|status|run)
    echo "Harness command accepted: $COMMAND"
    echo "Phase 0.17 control-plane foundation: command contract only."
    ;;
  *)
    echo "Unknown harness command: $COMMAND"
    echo "Use: init doctor install configure develop plan test security validate deploy upgrade rollback status run"
    exit 2
    ;;
esac
