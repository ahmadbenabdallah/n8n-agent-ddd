-- Protected mapping for headless Store API carts.
-- Encrypt the token at application/storage level; never log it.
create table if not exists wc_cart_sessions (
  id bigserial primary key,
  customer_id text not null,
  channel text not null,
  store_id text not null,
  cart_reference text not null unique,
  encrypted_cart_token text not null,
  status text not null default 'active' check (status in ('active','invalid','expired')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(customer_id, channel, store_id)
);

create index if not exists wc_cart_sessions_lookup
  on wc_cart_sessions(customer_id, channel, store_id);
