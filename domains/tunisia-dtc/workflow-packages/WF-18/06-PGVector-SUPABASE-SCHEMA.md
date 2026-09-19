# Supabase + pgvector Model

Suggested tables:

## kb_documents

- id
- document_id
- tenant_id
- source_type
- title
- owner
- language
- script
- version
- status
- content_hash
- effective_from
- effective_until
- sensitivity
- created_at
- updated_at

## kb_chunks

- id
- document_id
- version
- chunk_id
- tenant_id
- content
- content_hash
- embedding
- embedding_model
- embedding_version
- heading_path
- language
- script
- effective_from
- effective_until
- sensitivity
- metadata
- created_at

## kb_publications

- document_id
- version
- published_at
- published_by
- rollback_of
- publication_hash

## RLS

Retrieval must enforce tenant/store scope.

Ingestion credentials must not be available to customer-facing runtime workflows.

Customer-facing retrieval should be read-only.
