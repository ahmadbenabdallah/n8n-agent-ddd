-- Approximate nearest-neighbour index for knowledge retrieval (cosine distance).
CREATE INDEX IF NOT EXISTS knowledge_documents_embedding_hnsw_idx
ON public.knowledge_documents USING hnsw (embedding vector_cosine_ops);
