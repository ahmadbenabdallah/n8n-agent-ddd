# WF-19 Test Cases

T01 — all services healthy, no anomalies → `healthy`, severity `ok`.

T02 — n8n unhealthy → warning alert.

T03 — OpenAI unhealthy → warning alert.

T04 — commerce unhealthy → warning alert.

T05 — stuck execution >0 → warning.

T06 — queue depth >100 → warning.

T07 — >10 execution failures/hour → warning.

T08 — KB older than 72h → `kb_stale`.

T09 — quarantined KB documents >0 → warning.

T10 — confirmed security incident → critical.

T11 — transaction verification failures >5 → warning.

T12 — invalid monitoring input → rejected.

T13 — raw CVV in monitoring payload → should not be accepted by production ingestion; alert payload must not contain it.

T14 — raw customer message in alert metadata → must be excluded.

T15 — alert adapter unavailable → snapshot still persists if possible; notification retry/dead-letter handled operationally.

T16 — monitoring workflow must not change `execution_allowed` or commerce state.

T17 — threshold tuning changes warning behavior deterministically.

T18 — repeated critical security alerts should be deduplicated at the alerting layer using event/incident IDs.
