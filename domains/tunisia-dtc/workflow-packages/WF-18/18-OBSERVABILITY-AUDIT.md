# WF-18 Observability & Audit

Track:
- ingestion runs;
- source status;
- validation failures;
- quarantines;
- approval actions;
- publication transitions;
- embedding failures;
- vector upserts;
- retrieval health;
- rollback events;
- supersession;
- poisoning detections.

Correlate with:
- `run_id`;
- `source_id`;
- `document_id`;
- `document_version`;
- `chunk_id`.

Do not log raw secrets or unnecessary sensitive source content.

Emit structured events to WF-17.
