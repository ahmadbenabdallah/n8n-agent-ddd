# WF-18 — KB Ingestion v1

Secure ingestion pipeline for the Tunisia DTC knowledge base and Supabase/pgvector.

## Pipeline

Markdown documents
→ normalize
→ frontmatter validation
→ poisoning/injection scan
→ quarantine or continue
→ deterministic chunking
→ embedding adapter
→ vector/document upsert adapter
→ audit

## Important

This workflow treats KB content as untrusted input during ingestion. A document that contains prompt-injection/tool-execution instructions is quarantined.

The workflow does not make the KB a source of live transactional truth. Product price, stock, order status and promotion validity must come from live services.

The package uses explicit adapter boundaries for embeddings and persistence so no fake API calls are hidden in the n8n JSON.
