# KB & Vector Maintenance

WF-19 monitors WF-18 outputs.

Check:
- ingestion failures;
- quarantined documents;
- stale published versions;
- missing embeddings;
- vector dimension mismatch;
- retrieval latency;
- retrieval failure;
- index health;
- source/version conflicts.

Maintenance:
- rebuild affected vectors;
- re-run failed ingestion;
- invalidate stale cache;
- verify publication state;
- trigger controlled rollback.

WF-19 cannot approve business knowledge. WF-18 approval remains the publication gate.
