-- Reference only; adapt to the actual commerce database.
-- The commerce system must own authoritative promotion usage.

create table if not exists promotion_usage_ledger (
  id bigserial primary key,
  promotion_id text not null,
  customer_ref text,
  order_ref text,
  usage_key text not null unique,
  status text not null check (status in ('reserved','consumed','released')),
  created_at timestamptz not null default now(),
  consumed_at timestamptz
);

create index if not exists idx_promotion_usage_customer
  on promotion_usage_ledger(customer_ref);

-- Do not increment usage in n8n before final commerce authorization.
-- Prefer an atomic reservation/consume operation in the commerce service.
