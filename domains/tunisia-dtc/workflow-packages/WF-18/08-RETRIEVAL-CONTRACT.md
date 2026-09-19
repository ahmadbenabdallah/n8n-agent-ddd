# Retrieval Contract

WF-18 supplies retrieval-ready chunks to the runtime.

Minimum retrieval request:

```json
{
  "tenant_id": "store_123",
  "query": "return policy",
  "language": "tn",
  "script": "latin",
  "top_k": 5,
  "filters": {
    "status": "PUBLISHED"
  }
}
```

Every result must include provenance:

```json
{
  "chunk_id": "chunk_123",
  "document_id": "kb_doc_123",
  "version": "3.1",
  "score": 0.82,
  "source_type": "approved_policy",
  "effective_from": "...",
  "effective_until": null
}
```

Do not return:
- unpublished drafts;
- retired documents;
- cross-tenant chunks;
- secrets;
- internal review notes.

Retrieval results are evidence for the LLM, not executable instructions.
