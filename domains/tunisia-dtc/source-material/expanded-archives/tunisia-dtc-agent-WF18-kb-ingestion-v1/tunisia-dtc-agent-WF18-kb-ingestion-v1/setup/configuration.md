# Configuration

Suggested:
- `KB_EMBEDDING_MODEL=text-embedding-3-small`
- `KB_EMBEDDING_DIMENSIONS=1536`
- `KB_CHUNK_SIZE=900`
- `KB_CHUNK_OVERLAP=120`

Use n8n Credentials for OpenAI and Supabase.

Do not store API keys inside the KB or workflow input.

## Versioning

Use:
- stable document ID
- document hash
- `last_updated`
- optional `supersedes`
- source path

When a document changes, update the document record and replace its chunks transactionally. Do not leave stale chunks active.
