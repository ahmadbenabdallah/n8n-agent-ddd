#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
echo "Agent topology: $ROOT/spec/harness/agent-topology.yaml"
echo "Task graph: $ROOT/spec/harness/task-graph-contract.yaml"
echo "Autonomy policy: $ROOT/spec/harness/autonomy-policy.yaml"
