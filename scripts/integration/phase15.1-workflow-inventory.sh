#!/usr/bin/env bash
set -euo pipefail

: "${N8N_BASE_URL:=http://127.0.0.1:5678}"
: "${EVIDENCE_DIR:=runtime/evidence/phase-15.1}"
: "${EXPECTED_COUNT:=21}"

mkdir -p "$EVIDENCE_DIR"

if [[ "${ALLOW_LIVE_RUNTIME:-NO}" != "YES" ]]; then
  printf '%s\n' '{"status":"NOT_EXECUTED","reason":"ALLOW_LIVE_RUNTIME is not YES"}' > "$EVIDENCE_DIR/inventory.json"
  echo "NOT_EXECUTED: live workflow inventory is opt-in."
  exit 2
fi

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl required"; exit 1; }

if [[ -z "${N8N_API_KEY:-}" ]]; then
  printf '%s\n' '{"status":"NOT_EXECUTED","reason":"N8N_API_KEY is required for authenticated inventory"}' > "$EVIDENCE_DIR/inventory.json"
  echo "NOT_EXECUTED: N8N_API_KEY is required."
  exit 2
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

http_code="$(
  curl -sS -o "$tmp" -w '%{http_code}' \
    --max-time 20 \
    -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
    "${N8N_BASE_URL}/api/v1/workflows?limit=250"
)"

if [[ "$http_code" != "200" ]]; then
  printf '%s\n' "{\"status\":\"FAIL\",\"http_status\":\"${http_code}\"}" > "$EVIDENCE_DIR/inventory.json"
  echo "FAIL: workflow API returned HTTP ${http_code}."
  exit 1
fi

python3 - "$tmp" "$EVIDENCE_DIR/inventory.json" "$EXPECTED_COUNT" <<'PY'
import json, sys
src, dst, expected = sys.argv[1], sys.argv[2], int(sys.argv[3])
data = json.load(open(src, encoding="utf-8"))
items = data.get("data", data if isinstance(data, list) else [])
names = [str(x.get("name","")) for x in items]
canonical = [n for n in names if n.startswith("WF-")]
out = {
    "status": "PASS" if len(canonical) == expected else "FAIL",
    "workflow_count_observed": len(canonical),
    "expected_count": expected,
    "workflow_names": sorted(canonical),
    "note": "Names are inventory evidence only; canonical identity must be validated separately."
}
json.dump(out, open(dst, "w", encoding="utf-8"), indent=2)
if out["status"] != "PASS":
    raise SystemExit(1)
PY

echo "PASS: live workflow inventory count matched ${EXPECTED_COUNT}."
