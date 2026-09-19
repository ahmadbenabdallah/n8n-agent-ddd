# Supabase + pgvector Contract

Suggested tables:

## kb_sources

- source_id
- source_uri
- source_type
- owner
- classification
- trust_class
- language
- script
- version
- content_hash
- status
- effective_from
- effective_until
- created_at
- updated_at

## kb_documents

- document_id
- source_id
- version
- title
- content_hash
- approval_status
- published_at
- superseded_at

## kb_chunks

- chunk_id
- document_id
- content
- embedding
- metadata
- content_hash
- created_at

## kb_ingestion_runs

- run_id
- source_id
- source_version
- status
- chunks_created
- chunks_rejected
- embedding_model
- embedding_dimension
- started_at
- completed_at
- error_code

## Retrieval requirements

Production retrieval should filter for:
- approved/published state;
- valid effective date;
- allowed classification;
- allowed source trust class.

Use pgvector similarity plus deterministic metadata filters.

Never retrieve a quarantined/rejected chunk into production customer answers.
