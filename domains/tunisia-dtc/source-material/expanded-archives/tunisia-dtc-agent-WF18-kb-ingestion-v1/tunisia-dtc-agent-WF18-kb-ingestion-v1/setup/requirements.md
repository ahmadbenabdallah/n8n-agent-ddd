# Requirements

- n8n
- Supabase Postgres + pgvector
- OpenAI embeddings or compatible embedding service
- approved KB repository/source
- audit workflow WF-17
- document review/quarantine process

## Recommended embedding
`text-embedding-3-small`, 1536 dimensions.

## Input
`documents[]` with:
- filename/path
- Markdown content
- optional source

## Production controls
- only approved repository/service account may trigger ingestion
- immutable/versioned source files
- document hash/version
- review/quarantine workflow
- no customer/order data in KB
