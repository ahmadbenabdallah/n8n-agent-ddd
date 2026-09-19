# Supabase + pgvector Contract

Suggested tables:

## kb_sources
- id
- source_id
- source_uri
- source_type
- trust_class
- owner
- checksum
- version
- status
- effective_from
- effective_until
- approval_reference
- created_at
- updated_at

## kb_documents
- id
- source_id
- document_version
- normalized_content_ref
- language
- category
- checksum
- status
- ingestion_run_id

## kb_chunks
- id
- chunk_id
- document_id
- content
- embedding
- metadata
- status
- created_at

## kb_ingestion_runs
- id
- source_id
- status
- started_at
- completed_at
- parser_version
- embedding_model
- chunker_version
- error_code

## kb_approvals
- id
- document_id
- reviewer_reference
- decision
- reason
- created_at

Production retrieval should filter:
`status = PUBLISHED`
and applicable effective dates.

Use RLS and least privilege. Do not expose ingestion controls to customer-facing workflows.
