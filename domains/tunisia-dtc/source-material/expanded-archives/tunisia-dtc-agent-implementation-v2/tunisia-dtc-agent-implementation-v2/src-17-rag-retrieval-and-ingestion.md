# RAG Retrieval & Ingestion

## Ingestion
`Source → Fetch → Normalize → Schema Validation → Provenance → Security Scan → Approval → Chunk → Embed → Index → Retrieval Test → Activate`

## Vector metadata
`document_id`, `version`, `type`, `market`, `language`, `status`, `effective_from`, `expires_at`, `source`, `approved`.

## Retrieval priority
1. Exact product/SKU.
2. Exact policy topic.
3. Structured filters.
4. Semantic similarity.
5. Optional reranking.

## Security
Quarantine content containing hidden instructions, secret-extraction requests, policy-override instructions, suspicious encoded payloads or executable content.

## Evaluation
Track recall@k, precision@k, grounded-answer rate, source correctness, stale-document rate, cross-market retrieval and cross-customer retrieval.
