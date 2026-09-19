create table if not exists public.wc_cart_sessions (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  channel text not null check (channel in ('facebook','whatsapp','instagram','internal')),
  store_id text not null default 'default',
  cart_reference text not null,
  encrypted_cart_token text,
  status text not null default 'active'
    check (status in ('active','expired','invalidated')),
  last_validated_at timestamptz,
  last_cart_hash text,
  version bigint not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(customer_id, channel, store_id)
);

create index if not exists idx_wc_cart_sessions_customer
  on public.wc_cart_sessions(customer_id, channel, status);

alter table public.wc_cart_sessions enable row level security;
