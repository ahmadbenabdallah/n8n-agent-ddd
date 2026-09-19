#!/usr/bin/env bash
set -euo pipefail

echo "Production smoke-test contract"
echo "1. ingress reachable"
echo "2. n8n runtime healthy"
echo "3. database connectivity healthy"
echo "4. Redis/queue healthy"
echo "5. domain workflow registry healthy"
echo "6. authorization boundary healthy"
echo "7. commerce adapter verification path healthy"
echo "8. audit path healthy"
echo
echo "External execution is required for production evidence."
