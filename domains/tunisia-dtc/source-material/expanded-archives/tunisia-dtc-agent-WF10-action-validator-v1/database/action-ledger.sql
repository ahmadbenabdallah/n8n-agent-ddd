-- Conceptual durable idempotency ledger.
create table if not exists action_ledger (
  id uuid primary key default gen_random_uuid(),
  idempotency_key text unique not null,
  conversation_id text not null,
  message_id text not null,
  action text not null,
  status text not null check (status in ('authorized','executing','executed','failed','expired')),
  service_reference text,
  result_hash text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- In production, enforce the unique idempotency_key constraint transactionally.
