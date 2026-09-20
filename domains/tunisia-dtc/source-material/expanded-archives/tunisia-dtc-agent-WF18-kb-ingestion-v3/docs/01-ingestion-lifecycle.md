# Ingestion Lifecycle

```text
Source
  ↓
WF-18 Validate
  ↓
Security scan
  ↓
Classify / sanitize
  ↓
Versioned document
  ↓
Chunk
  ↓
Embedding generation
  ↓
pgvector
  ↓
Retrieval
```

The supplied v3 n8n workflow establishes validation, security scanning, versioning and chunk storage.

**Embedding generation is an explicit production integration step** and should use the configured embedding model through a controlled node/service. Do not silently assume a model or dimension.

The included migration uses 1536 dimensions as a placeholder compatible with a common embedding configuration; verify this against the actual embedding model before applying to production.
