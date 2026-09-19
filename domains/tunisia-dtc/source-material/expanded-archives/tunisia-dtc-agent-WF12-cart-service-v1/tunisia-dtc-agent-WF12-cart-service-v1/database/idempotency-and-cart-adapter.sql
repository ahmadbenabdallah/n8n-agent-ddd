-- WF-12 production persistence reference
-- Adapt to your commerce DB. Do not store payment secrets here.

create table if not exists cart_action_ledger (
  id bigserial primary key,
  idempotency_key text not null unique,
  action text not null,
  cart_id text,
  actor_ref text,
  request_hash text not null,
  status text not null check (status in ('accepted','completed','failed','rejected')),
  adapter_operation_id text,
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

create index if not exists idx_cart_action_ledger_cart
  on cart_action_ledger(cart_id);

-- Recommended transaction:
-- 1. INSERT idempotency_key with unique constraint.
-- 2. If duplicate exists, return prior result.
-- 3. Execute cart mutation atomically.
-- 4. Record adapter operation id/result.
-- 5. Verify cart owner + version.
