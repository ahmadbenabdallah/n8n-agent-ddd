#!/usr/bin/env bash
set -euo pipefail
for wf in WF-01 WF-10 WF-15 WF-20; do test -d "domains/tunisia-dtc/workflows/$wf"; done
grep -q 'mcp_cannot_bypass_wf10: true' spec/security/protected-workflow-policy.yaml
echo "PHASE 13.6 PROTECTED WORKFLOW POLICY PASS"
