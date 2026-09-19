create extension if not exists vector;

create table if not exists public.kb_documents (
  id uuid primary key default gen_random_uuid(),
  source_id text not null,
  source_type text not null,
  source_uri text,
  language text,
  version text not null,
  status text not null check(status in ('active','disabled','quarantined')),
  content text not null,
  security_flags jsonb not null default '[]'::jsonb,
  source_role text not null default 'approved_business_knowledge',
  created_at timestamptz not null default now(),
  unique(source_id,version)
);

create table if not exists public.kb_chunks (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.kb_documents(id) on delete cascade,
  chunk_index integer not null,
  content text not null,
  embedding vector(1536),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique(document_id,chunk_index)
);

create index if not exists idx_kb_documents_active
on public.kb_documents(source_id,version) where status='active';

create index if not exists idx_kb_chunks_document
on public.kb_chunks(document_id);

alter table public.kb_documents enable row level security;
alter table public.kb_chunks enable row level security;
