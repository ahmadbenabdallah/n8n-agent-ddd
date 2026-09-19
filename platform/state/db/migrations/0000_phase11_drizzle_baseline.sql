CREATE EXTENSION IF NOT EXISTS vector;

-- Drizzle owns the typed application schema. This SQL migration retains
-- PostgreSQL-specific capabilities that must remain explicit and reviewable.

CREATE INDEX IF NOT EXISTS knowledge_documents_embedding_hnsw_idx
ON knowledge_documents USING hnsw (embedding vector_cosine_ops);

-- Defense-in-depth: application tables remain inaccessible to public roles.
DO $$
DECLARE
  tbl text;
BEGIN
  FOREACH tbl IN ARRAY ARRAY[
    'customer_identity',
    'conversations',
    'carts',
    'actions',
    'authorizations',
    'idempotency_keys',
    'audit_events',
    'knowledge_documents'
  ]
  LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', tbl);
    EXECUTE format('REVOKE ALL ON TABLE %I FROM anon, authenticated', tbl);
  END LOOP;
END $$;
