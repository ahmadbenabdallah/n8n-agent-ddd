# Embedding Versioning

Embedding configuration is part of the KB version.

Record:
- embedding provider;
- model identifier;
- model version if available;
- vector dimension;
- preprocessing version;
- chunking version;
- embedding timestamp.

When changing embedding dimensions/models:
- build a new index/version;
- validate retrieval quality;
- dual-run if appropriate;
- switch via controlled release;
- retain rollback capability.

Do not silently mix incompatible vector dimensions or preprocessing versions.
