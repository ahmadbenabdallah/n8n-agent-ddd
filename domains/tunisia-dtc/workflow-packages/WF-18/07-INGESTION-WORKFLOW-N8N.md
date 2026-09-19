# n8n Ingestion Workflow

Recommended WF-18 topology:

```text
Trigger
 -> Source Registry Lookup
 -> Download / Read Source
 -> Size / Type Guard
 -> Parse
 -> Normalize
 -> Secret Scanner
 -> Prompt Injection Scanner
 -> Policy Classification
 -> Content Hash
 -> Duplicate Check
 -> Chunk
 -> Metadata Validator
 -> Embedding
 -> Vector Upsert
 -> Quality Checks
 -> Approval Gate
 -> Publish
 -> Audit
```

## Approval gate

For production business knowledge, publication must be explicit.

The ingestion workflow may prepare a candidate version but must not silently publish a high-impact policy change.

## Failure

If any mandatory security/validation step fails:
- mark ingestion failed or quarantined;
- do not publish;
- emit audit event;
- preserve source reference safely;
- alert when severity warrants.
