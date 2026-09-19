-- Reuse/merge with the existing commerce_idempotency table if already deployed.
create table if not exists commerce_idempotency (
  id bigserial primary key,
  idempotency_key text not null unique,
  operation text not null,
  customer_id text not null,
  conversation_id text not null,
  status text not null check (status in ('started','succeeded','failed')),
  commerce_order_id text,
  response_hash text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists commerce_idempotency_customer_idx
  on commerce_idempotency(customer_id, created_at desc);
