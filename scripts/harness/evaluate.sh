#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
echo "Evaluation contract: $ROOT/spec/harness/evaluation-contract.yaml"
echo "Self-improvement remains evidence- and review-gated."
