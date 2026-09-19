# WF-18 Observability & Audit

Record:
- ingestion_run_id;
- source_id;
- document version;
- checksum;
- parser version;
- chunker version;
- embedding model/version;
- number of chunks;
- validation results;
- security scan result;
- approval result;
- publication timestamp;
- supersession/rollback event;
- errors;
- processing duration.

Metrics:
- ingestion success/failure;
- quarantine rate;
- processing latency;
- chunk counts;
- embedding failure rate;
- retrieval hit rate;
- stale-content retrieval attempts;
- conflicting-policy detections;
- poisoning detections.

Never log source secrets or unrestricted private customer content.
