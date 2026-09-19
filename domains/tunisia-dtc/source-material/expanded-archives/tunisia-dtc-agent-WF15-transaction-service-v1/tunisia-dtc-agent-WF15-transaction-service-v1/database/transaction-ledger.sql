create table if not exists transaction_action_ledger (
  id bigserial primary key,
  idempotency_key text not null unique,
  action text not null,
  checkout_id text not null,
  cart_id text not null,
  request_hash text not null,
  status text not null check (status in ('accepted','created','authorized','captured','failed','unknown','rejected')),
  transaction_id text,
  order_id text,
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

create index if not exists idx_transaction_ledger_checkout
  on transaction_action_ledger(checkout_id);

-- The unique idempotency key must be enforced transactionally.
-- Never store PAN/CVV/OTP/PIN/payment passwords.
