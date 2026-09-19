# Retrieval Contract

WF-18 exposes indexed knowledge to the retrieval layer through approved metadata.

Retrieval result should contain:

```json
{
  "chunk_id": "chunk_123",
  "source_id": "source_123",
  "document_version": "v4",
  "content": "...",
  "classification": "POLICY",
  "language": "fr",
  "script": "latin",
  "approved": true,
  "effective": true,
  "score": 0.87
}
```

The retrieval layer must preserve provenance.

A similarity score is not proof of correctness.

If no sufficiently trusted/approved result exists, WF-09 must propose clarification or a live lookup rather than inventing a fact.
