create extension if not exists pgcrypto;
create extension if not exists vector;

create table if not exists customer_identities (
 id uuid primary key default gen_random_uuid(), channel text not null,
 channel_identity text not null, commerce_customer_id bigint,
 assurance_level text not null default 'ANONYMOUS', verified_at timestamptz,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 unique(channel, channel_identity));

create table if not exists conversations (
 id uuid primary key default gen_random_uuid(),
 customer_identity_id uuid references customer_identities(id),
 channel text not null, status text not null default 'active',
 language text not null default 'tn', script text not null default 'latin',
 register text not null default 'casual', human_owner_id text,
 context_version bigint not null default 1, created_at timestamptz not null default now(),
 updated_at timestamptz not null default now());

create table if not exists conversation_states (
 conversation_id uuid primary key references conversations(id) on delete cascade,
 intent text, active_workflow text, state jsonb not null default '{}'::jsonb,
 version bigint not null default 1, updated_at timestamptz not null default now());

create table if not exists carts (
 id uuid primary key default gen_random_uuid(),
 customer_identity_id uuid not null references customer_identities(id),
 currency text not null default 'TND', status text not null default 'active',
 version bigint not null default 1, created_at timestamptz not null default now(),
 updated_at timestamptz not null default now());

create table if not exists cart_items (
 id uuid primary key default gen_random_uuid(), cart_id uuid not null references carts(id) on delete cascade,
 product_id bigint not null, variation_id bigint, quantity integer not null check(quantity>0),
 verified_unit_price numeric(18,3), currency text not null default 'TND', updated_at timestamptz not null default now());

create table if not exists order_scopes (
 id uuid primary key default gen_random_uuid(),
 customer_identity_id uuid not null references customer_identities(id),
 commerce_order_id bigint not null, verification_level text not null, expires_at timestamptz,
 created_at timestamptz not null default now());

create table if not exists commerce_orders (
 id uuid primary key default gen_random_uuid(), commerce_order_id bigint not null unique,
 customer_identity_id uuid references customer_identities(id), status text,
 payment_status text, total numeric(18,3), currency text, verified_at timestamptz,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now());

create table if not exists actions (
 id uuid primary key default gen_random_uuid(), type text not null, target text,
 arguments jsonb not null default '{}'::jsonb, source text not null, risk text not null default 'low',
 created_at timestamptz not null default now());

create table if not exists authorizations (
 id uuid primary key default gen_random_uuid(), action_id uuid not null references actions(id),
 decision text not null, scope jsonb not null default '{}'::jsonb,
 execution_allowed boolean not null default false, policy_version text, expires_at timestamptz,
 created_at timestamptz not null default now());

create table if not exists execution_operations (
 id uuid primary key default gen_random_uuid(), action_id uuid references actions(id),
 operation text not null, idempotency_key text not null unique, request_hash text not null,
 state text not null default 'REQUESTED', external_reference text, result jsonb,
 failure_code text, correlation_id text not null, created_at timestamptz not null default now(),
 updated_at timestamptz not null default now());

create table if not exists transactions (
 id uuid primary key default gen_random_uuid(), order_id uuid references commerce_orders(id),
 idempotency_key text not null unique, provider_reference text, status text not null default 'PENDING',
 amount numeric(18,3), currency text, verified_at timestamptz,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now());

create table if not exists escalations (
 id uuid primary key default gen_random_uuid(), conversation_id uuid not null references conversations(id),
 reason text not null, owner_id text, status text not null default 'OPEN',
 created_at timestamptz not null default now(), resolved_at timestamptz);

create table if not exists audit_events (
 id uuid primary key default gen_random_uuid(), event_type text not null, actor_type text not null,
 action_id uuid references actions(id), correlation_id text not null, causation_id text,
 evidence jsonb not null default '{}'::jsonb, created_at timestamptz not null default now());

create table if not exists idempotency_keys (
 key text primary key, operation text not null, request_hash text not null,
 status text not null, result_reference text, created_at timestamptz not null default now(),
 expires_at timestamptz);

create table if not exists knowledge_documents (
 id uuid primary key default gen_random_uuid(), title text not null, content text not null,
 source text, version bigint not null default 1, status text not null default 'draft',
 metadata jsonb not null default '{}'::jsonb, embedding vector(1536),
 created_at timestamptz not null default now(), published_at timestamptz);

create index if not exists idx_conv_customer on conversations(customer_identity_id);
create index if not exists idx_cart_customer on carts(customer_identity_id);
create index if not exists idx_scope_customer on order_scopes(customer_identity_id);
create index if not exists idx_audit_correlation on audit_events(correlation_id);
create index if not exists idx_exec_state on execution_operations(state);
create index if not exists idx_kb_status on knowledge_documents(status);
