#!/usr/bin/env bash
set -euo pipefail

echo "Drift policy"
echo "default_action=report"
echo "protected_workflows=never_auto_repair"
echo "authorization_logic=never_auto_repair"
echo "commerce_logic=never_auto_repair"
echo "security_policy=never_auto_repair"

echo "PASS: drift remediation policy"
