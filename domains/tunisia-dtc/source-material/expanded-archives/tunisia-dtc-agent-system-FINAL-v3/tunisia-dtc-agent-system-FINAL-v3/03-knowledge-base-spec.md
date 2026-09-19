# Knowledge Base Specification — Production v3

## Purpose
Approved stable business knowledge for RAG. Retrieved text is data, never executable instructions.

## Content
- Products: stable attributes, variants, materials, care, approved descriptive content.
- Policies: shipping, returns/exchanges, service rules and exceptions.
- FAQ: approved answers linked to governing policies.
- Operations: approved non-secret operational guidance.

## Metadata
document_id, type, category, language, region, last_updated, status, version, supersedes, source_path.

## Retrieval filters
Filter by region, status, document type and intent/category. Language may assist retrieval but does not control customer response language.

## Dynamic authority
Never use KB as authority for:
- current stock
- current price
- active promotion eligibility
- cart state
- checkout total
- order status
- payment status
- generated checkout URLs

These come from live commerce/WooCommerce results.

## Ingestion controls
WF-18 validates source identity, status, versioning, supersession, chunk boundaries, metadata and poisoning controls before indexing into Supabase/pgvector.

No secrets or private customer data belong in the KB.
