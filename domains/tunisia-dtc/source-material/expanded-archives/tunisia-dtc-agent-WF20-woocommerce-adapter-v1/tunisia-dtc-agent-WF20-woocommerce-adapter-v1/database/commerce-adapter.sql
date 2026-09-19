create table if not exists commerce_idempotency (
  id bigserial primary key,
  idempotency_key text not null unique,
  operation text not null,
  request_hash text not null,
  status text not null check (status in ('reserved','succeeded','failed','awaiting_verification')),
  external_resource_type text,
  external_resource_id text,
  response_json jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists commerce_idempotency_operation_idx
  on commerce_idempotency(operation);

create table if not exists commerce_orders (
  id bigserial primary key,
  external_order_id bigint not null unique,
  external_order_number text,
  channel text,
  conversation_id text,
  idempotency_key text,
  status text,
  currency text,
  total numeric(18,3),
  payment_method text,
  verified_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Optional agent-side cart snapshot. This is deliberately separate from WooCommerce.
create table if not exists agent_carts (
  id bigserial primary key,
  cart_id text not null unique,
  identity_key text not null,
  channel text,
  state text not null default 'active',
  version integer not null default 1,
  items jsonb not null default '[]'::jsonb,
  currency text,
  subtotal numeric(18,3),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
