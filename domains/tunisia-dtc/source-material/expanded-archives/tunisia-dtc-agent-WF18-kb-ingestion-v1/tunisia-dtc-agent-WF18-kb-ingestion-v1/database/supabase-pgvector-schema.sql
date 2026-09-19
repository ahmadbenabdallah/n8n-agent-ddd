create extension if not exists vector;

create table if not exists kb_documents (
  id text primary key,
  type text not null,
  category text,
  last_updated date not null,
  source_path text not null,
  document_hash text not null,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists kb_chunks (
  chunk_id text primary key,
  document_id text not null references kb_documents(id) on delete cascade,
  chunk_text text not null,
  embedding vector(1536) not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists kb_chunks_metadata_gin
  on kb_chunks using gin(metadata);

create index if not exists kb_chunks_embedding_hnsw
  on kb_chunks using hnsw (embedding vector_cosine_ops);

-- Replace old chunks transactionally when a document hash changes.
-- Only active documents should be eligible for retrieval.
