#!/usr/bin/env bash
set -euo pipefail

echo "== Phase 10 production-readiness execution =="
echo "1/7 Preflight"
pnpm staging:preflight

echo "2/7 Workflow and contract validation"
pnpm readiness:workflows
pnpm readiness:contracts

echo "3/7 Staging smoke"
pnpm staging:smoke

echo "4/7 Execute operator-provided evidence suites"
echo "Run the required staging suites documented in docs/operations/production-certification.md."
echo "Each suite must write evidence/phase-10/runs/<run-id>/<gate>.json"

echo "5/7 Evaluate evidence"
pnpm readiness:evaluate || true

echo "6/7 Inspect certification decision"
cat evidence/phase-10/certification.json

echo "7/7 Production remains blocked unless decision=CERTIFIED and all deployment gates pass."
