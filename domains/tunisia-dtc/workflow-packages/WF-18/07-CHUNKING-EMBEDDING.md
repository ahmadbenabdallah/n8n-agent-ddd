# Chunking & Embedding

Chunking should preserve semantic units.

Prefer boundaries:
- heading;
- section;
- FAQ question/answer;
- policy rule;
- product specification section.

Avoid splitting:
- policy conditions;
- tables containing related values;
- sentence-level exceptions;
- warnings from their context.

Each chunk should include metadata:

```json
{
  "chunk_id": "chunk_123",
  "source_id": "kb_123",
  "document_version": "v4",
  "category": "returns_exchange_policy",
  "language": "fr",
  "status": "PUBLISHED",
  "effective_from": "2026-01-01",
  "effective_until": null,
  "checksum": "sha256:...",
  "embedding_model": "configured-model"
}
```

Embedding model/version must be recorded so re-indexing is reproducible.
