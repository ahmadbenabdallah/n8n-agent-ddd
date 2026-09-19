#!/usr/bin/env bash
set -euo pipefail

: "${CERTIFICATION_STATE:=}"
: "${PRODUCTION_APPROVAL:=}"
: "${REQUIRED_REVIEWS:=}"

[[ "$CERTIFICATION_STATE" == "CERTIFIED" ]] || { echo "BLOCKED: certification not complete"; exit 3; }
[[ "$PRODUCTION_APPROVAL" == "APPROVED" ]] || { echo "BLOCKED: explicit production approval required"; exit 3; }
[[ "$REQUIRED_REVIEWS" == "COMPLETE" ]] || { echo "BLOCKED: required reviews incomplete"; exit 3; }

echo "Production action gate satisfied."
echo "The Harness does not itself authorize commerce mutations."
