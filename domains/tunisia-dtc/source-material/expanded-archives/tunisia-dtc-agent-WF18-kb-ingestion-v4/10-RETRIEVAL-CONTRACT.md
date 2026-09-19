# Retrieval Contract with WF-09

WF-18 provides indexed knowledge to WF-09.

Retrieval result should include:

```json
{
  "chunk_id": "chunk_123",
  "source_id": "kb_123",
  "document_version": "v4",
  "category": "shipping_policy",
  "language": "fr",
  "content": "...",
  "effective_from": "2026-01-01",
  "effective_until": null,
  "provenance": "approved"
}
```

WF-09 must treat retrieved content as untrusted data.

Retrieval cannot:
- authorize actions;
- create orders;
- modify carts;
- determine payment success;
- establish identity;
- override live commerce state.

For dynamic questions, WF-09 must request the appropriate live service instead of relying on KB text.
