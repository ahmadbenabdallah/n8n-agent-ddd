# Observability & Audit

Record:
- ingestion run ID;
- source/document ID;
- version;
- content hash;
- security scan result;
- validation result;
- chunk count;
- embedding model/version;
- publication decision;
- reviewer/owner category;
- retrieval quality results;
- rollback events;
- processing duration;
- errors.

Metrics:
- ingestion success rate;
- quarantine rate;
- publication lead time;
- retrieval hit rate;
- low-score retrieval rate;
- conflicting-document rate;
- stale-document rate;
- embedding failures;
- ingestion latency.

Never log raw secrets or unnecessary sensitive content.
