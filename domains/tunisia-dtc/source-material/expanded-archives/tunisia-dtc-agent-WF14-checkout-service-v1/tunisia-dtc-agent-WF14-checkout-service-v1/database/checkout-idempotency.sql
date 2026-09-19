create table if not exists checkout_action_ledger (
  id bigserial primary key,
  idempotency_key text not null unique,
  action text not null check (action in ('checkout_start','checkout_confirm')),
  cart_id text not null,
  cart_version text,
  request_hash text not null,
  status text not null check (status in ('accepted','completed','failed','rejected')),
  checkout_id text,
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

create index if not exists idx_checkout_ledger_cart
  on checkout_action_ledger(cart_id);

-- Use a transaction/unique constraint to make idempotency authoritative.
-- Do not store card data, CVV, OTP or payment authentication secrets.
