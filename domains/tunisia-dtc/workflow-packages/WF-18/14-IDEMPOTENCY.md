# Ingestion Idempotency

Use deterministic keys:

`tenant_id + document_id + version + content_hash`

Embedding upsert must be idempotent.

A repeated ingestion of the same content must not create uncontrolled duplicate chunks.

If the source content changes:
- content hash changes;
- create a new version or controlled revision;
- re-embed affected chunks.

Never mutate a published chunk in place in a way that destroys historical provenance.
