#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.5}"
mkdir -p "$EVIDENCE_DIR"

python3 - "$EVIDENCE_DIR/resilience-matrix.json" <<'PY'
import json, sys
faults = [
    "n8n_restart",
    "worker_unavailable",
    "postgres_connection_pressure",
    "commerce_provider_timeout",
    "commerce_provider_5xx",
    "channel_timeout",
    "queue_backlog",
    "transient_network_failure",
    "stale_runtime_lock"
]
json.dump({
    "status":"NOT_EXECUTED",
    "faults":[{"fault":x,"status":"NOT_EXECUTED"} for x in faults]
}, open(sys.argv[1],"w",encoding="utf-8"), indent=2)

for name, obj in {
    "latency-summary.json": {"status":"NOT_EXECUTED"},
    "error-summary.json": {"status":"NOT_EXECUTED"},
    "recovery-summary.json": {"status":"NOT_EXECUTED"}
}.items():
    json.dump(obj, open(sys.argv[1].rsplit("/",1)[0]+"/"+name,"w",encoding="utf-8"), indent=2)
PY

echo "Created non-certifying resilience evidence matrix."
