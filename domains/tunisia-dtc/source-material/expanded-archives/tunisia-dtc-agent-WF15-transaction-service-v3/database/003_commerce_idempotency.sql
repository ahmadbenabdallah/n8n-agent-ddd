create table if not exists public.commerce_idempotency (
  customer_id uuid not null references public.customers(id) on delete cascade,
  action_id text not null,
  operation text not null,
  status text not null check(status in ('pending','succeeded','failed')),
  result_json jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key(customer_id, action_id)
);

create index if not exists idx_commerce_idempotency_status
on public.commerce_idempotency(status, updated_at);

alter table public.commerce_idempotency enable row level security;
