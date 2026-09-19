#!/usr/bin/env bash
set -euo pipefail

echo "Post-promotion verification contract:"
echo " - active slot is expected slot"
echo " - health endpoint responds"
echo " - critical workflow registry is healthy"
echo " - WF-10 authorization path is healthy"
echo " - WF-20 verification path is healthy"
echo " - audit events are being written"
echo " - no critical alerts are firing"
echo
echo "Provider/runtime-specific checks must be implemented by the deployment adapter."
