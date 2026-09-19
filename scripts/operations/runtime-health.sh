#!/usr/bin/env bash
set -euo pipefail

echo "Runtime health policy check"
echo "control_loop=OBSERVE>CLASSIFY>DECIDE>ACT>VERIFY>AUDIT>LEARN"
echo "unknown_state=preserved"
echo "commerce_authorization=WF-10"
echo "commerce_execution=WF-20"

if [[ "${ENVIRONMENT:-local}" == "production" && "${ALLOW_LIVE_HEALTH:-NO}" != "YES" ]]; then
  echo "Production live health probe blocked unless ALLOW_LIVE_HEALTH=YES."
  exit 2
fi

echo "PASS: runtime health policy precheck"
