-- Supabase/PostgreSQL additive identity-graph migration.
create extension if not exists pgcrypto;

create table if not exists customers (
  customer_id uuid primary key default gen_random_uuid(),
  status text not null default 'active'
    check (status in ('active','blocked','merged','deleted')),
  identity_level integer not null default 0
    check (identity_level between 0 and 3),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists channel_identities (
  channel_identity_id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers(customer_id),
  channel text not null
    check (channel in ('facebook','instagram_dm','instagram_comment','whatsapp')),
  channel_subject_id text not null,
  relationship_status text not null default 'active'
    check (relationship_status in ('active','revoked','conflict')),
  first_seen_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  verified_at timestamptz,
  revoked_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  unique(channel, channel_subject_id)
);

create index if not exists idx_channel_identity_customer
  on channel_identities(customer_id);

create table if not exists commerce_identities (
  commerce_identity_id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers(customer_id),
  commerce_provider text not null
    check (commerce_provider in ('woocommerce')),
  commerce_customer_id text,
  external_key_hash text,
  relationship_status text not null default 'candidate'
    check (relationship_status in ('candidate','verified','revoked','conflict')),
  matched_at timestamptz,
  verified_at timestamptz,
  revoked_at timestamptz,
  metadata jsonb not null default '{}'::jsonb
);

create index if not exists idx_commerce_identity_customer
  on commerce_identities(customer_id);

create table if not exists customer_order_scope (
  order_scope_id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers(customer_id),
  commerce_provider text not null
    check (commerce_provider in ('woocommerce')),
  commerce_order_id text not null,
  scope_status text not null default 'pending'
    check (scope_status in ('pending','active','revoked','expired')),
  permissions jsonb not null default '[]'::jsonb,
  verification_method text,
  verification_event_id uuid,
  verified_at timestamptz,
  expires_at timestamptz,
  revoked_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(customer_id, commerce_provider, commerce_order_id),
  constraint active_scope_requires_verification
    check (scope_status <> 'active' or verified_at is not null)
);

create index if not exists idx_order_scope_customer_status
  on customer_order_scope(customer_id, scope_status);

create index if not exists idx_order_scope_order
  on customer_order_scope(commerce_provider, commerce_order_id);

create table if not exists identity_verification_events (
  verification_event_id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers(customer_id),
  channel_identity_id uuid references channel_identities(channel_identity_id),
  commerce_identity_id uuid references commerce_identities(commerce_identity_id),
  commerce_order_id text,
  previous_identity_level integer,
  resulting_identity_level integer,
  verification_method text not null,
  outcome text not null
    check (outcome in ('passed','failed','ambiguous','revoked')),
  reason_code text,
  created_at timestamptz not null default now(),
  metadata jsonb not null default '{}'::jsonb
);

create index if not exists idx_verification_customer
  on identity_verification_events(customer_id, created_at desc);

alter table customers enable row level security;
alter table channel_identities enable row level security;
alter table commerce_identities enable row level security;
alter table customer_order_scope enable row level security;
alter table identity_verification_events enable row level security;

-- Production RLS policies must follow the existing server-side/service-role
-- architecture. Do not grant customer-facing clients unrestricted write access.
