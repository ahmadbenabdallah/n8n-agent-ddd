create extension if not exists pgcrypto;

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  status text not null default 'active' check (status in ('active','blocked','deleted')),
  display_name text,
  phone_e164 text,
  address_text text,
  city text,
  postal_code text,
  country_code text default 'TN',
  preferred_language text,
  preferred_script text,
  preferred_register text,
  consent_status text not null default 'unknown'
    check (consent_status in ('unknown','granted','withdrawn')),
  last_channel text,
  last_seen_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.customer_identities (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  channel text not null check (channel in ('facebook','whatsapp','instagram','internal')),
  external_user_id text not null,
  identity_level integer not null default 1 check (identity_level between 0 and 3),
  verified_at timestamptz,
  first_seen_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(channel, external_user_id)
);

create index if not exists idx_customer_identities_customer
  on public.customer_identities(customer_id);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references public.customers(id) on delete set null,
  channel text not null check (channel in ('facebook','whatsapp','instagram','internal')),
  external_conversation_id text,
  status text not null default 'open' check (status in ('open','closed','escalated')),
  started_at timestamptz not null default now(),
  last_message_at timestamptz,
  last_turn_id text,
  turn_count integer not null default 0,
  automated_turn_count integer not null default 0,
  escalation_status text not null default 'none'
    check (escalation_status in ('none','pending','human_active','resolved')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_conversations_customer_last
  on public.conversations(customer_id, last_message_at desc);

create unique index if not exists uq_conversation_channel_external
  on public.conversations(channel, external_conversation_id)
  where external_conversation_id is not null;

create table if not exists public.conversation_context (
  conversation_id uuid primary key references public.conversations(id) on delete cascade,
  language text,
  script text,
  register text,
  intent text,
  sub_intent text,
  sales_stage text not null default 'NEW',
  identity_level integer not null default 0 check (identity_level between 0 and 3),
  selected_products jsonb not null default '[]'::jsonb,
  purchase_intent jsonb not null default '{}'::jsonb,
  customer_details jsonb not null default '{}'::jsonb,
  cart_reference text,
  order_scope jsonb,
  last_action_id text,
  last_message_hash text,
  last_customer_message text,
  commerce_status text not null default 'unknown'
    check (commerce_status in ('unknown','available','degraded','unavailable')),
  source_of_truth text not null default 'kb_only'
    check (source_of_truth in ('woocommerce','kb_only')),
  risk_flags jsonb not null default '[]'::jsonb,
  repetition_state jsonb not null default '{}'::jsonb,
  next_required_fields jsonb not null default '[]'::jsonb,
  version bigint not null default 1,
  last_updated timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.customer_purchase_intents (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  conversation_id uuid references public.conversations(id) on delete set null,
  product_ref jsonb,
  variant_ref jsonb,
  requested_quantity integer,
  requested_attributes jsonb not null default '{}'::jsonb,
  intent_status text not null default 'active'
    check (intent_status in ('active','paused','completed','cancelled')),
  commerce_ready boolean not null default false,
  last_commerce_validation_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_purchase_intents_customer_status
  on public.customer_purchase_intents(customer_id, intent_status, updated_at desc);

create table if not exists public.identity_resolution_events (
  id uuid primary key default gen_random_uuid(),
  channel text not null,
  external_user_id text,
  customer_id uuid references public.customers(id) on delete set null,
  conversation_id uuid references public.conversations(id) on delete set null,
  resolution_result text not null
    check (resolution_result in ('created','matched','rejected','blocked')),
  identity_level integer not null default 0,
  reason_code text,
  created_at timestamptz not null default now()
);

create or replace function public.resolve_channel_identity(
  p_channel text, p_external_user_id text, p_display_name text default null
)
returns table(customer_id uuid, identity_id uuid, identity_level integer, created_customer boolean)
language plpgsql security definer set search_path=public as $$
declare
  v_customer uuid; v_identity uuid; v_level integer; v_created boolean := false;
begin
  if p_channel not in ('facebook','whatsapp','instagram','internal') then raise exception 'invalid_channel'; end if;
  if p_external_user_id is null or length(trim(p_external_user_id))=0 then raise exception 'missing_external_user_id'; end if;

  select ci.customer_id, ci.id, ci.identity_level
    into v_customer, v_identity, v_level
    from customer_identities ci
   where ci.channel=p_channel and ci.external_user_id=p_external_user_id
   for update;

  if v_customer is null then
    insert into customers(display_name,last_channel,last_seen_at)
    values(nullif(trim(p_display_name),''),p_channel,now())
    returning id into v_customer;
    insert into customer_identities(customer_id,channel,external_user_id,identity_level)
    values(v_customer,p_channel,p_external_user_id,1)
    returning id,identity_level into v_identity,v_level;
    v_created := true;
  else
    update customer_identities set last_seen_at=now(),updated_at=now() where id=v_identity;
    update customers set last_channel=p_channel,last_seen_at=now(),updated_at=now() where id=v_customer;
  end if;

  insert into identity_resolution_events(channel,external_user_id,customer_id,resolution_result,identity_level)
  values(p_channel,p_external_user_id,v_customer,case when v_created then 'created' else 'matched' end,v_level);

  return query select v_customer,v_identity,v_level,v_created;
end $$;

create or replace function public.upsert_conversation(
  p_customer_id uuid, p_channel text, p_external_conversation_id text, p_turn_id text
) returns uuid language plpgsql security definer set search_path=public as $$
declare v_id uuid; v_level integer;
begin
  insert into conversations(customer_id,channel,external_conversation_id,last_message_at,last_turn_id,turn_count)
  values(p_customer_id,p_channel,p_external_conversation_id,now(),p_turn_id,1)
  on conflict(channel,external_conversation_id) where external_conversation_id is not null
  do update set customer_id=coalesce(conversations.customer_id,excluded.customer_id),
    last_message_at=now(),last_turn_id=excluded.last_turn_id,
    turn_count=conversations.turn_count+1,updated_at=now()
  returning id into v_id;

  select coalesce(ci.identity_level,1) into v_level
    from customer_identities ci
   where ci.customer_id=p_customer_id and ci.channel=p_channel
   order by ci.last_seen_at desc limit 1;

  insert into conversation_context(conversation_id,identity_level)
  values(v_id,coalesce(v_level,1))
  on conflict(conversation_id) do nothing;

  return v_id;
end $$;

create or replace function public.update_customer_profile(
  p_customer_id uuid, p_display_name text default null, p_phone_e164 text default null,
  p_address_text text default null, p_city text default null, p_postal_code text default null,
  p_preferred_language text default null, p_preferred_script text default null,
  p_preferred_register text default null
) returns void language plpgsql security definer set search_path=public as $$
begin
  update customers set
    display_name=coalesce(nullif(trim(p_display_name),''),display_name),
    phone_e164=coalesce(nullif(trim(p_phone_e164),''),phone_e164),
    address_text=coalesce(nullif(trim(p_address_text),''),address_text),
    city=coalesce(nullif(trim(p_city),''),city),
    postal_code=coalesce(nullif(trim(p_postal_code),''),postal_code),
    preferred_language=coalesce(nullif(trim(p_preferred_language),''),preferred_language),
    preferred_script=coalesce(nullif(trim(p_preferred_script),''),preferred_script),
    preferred_register=coalesce(nullif(trim(p_preferred_register),''),preferred_register),
    updated_at=now()
  where id=p_customer_id;
end $$;

alter table customers enable row level security;
alter table customer_identities enable row level security;
alter table conversations enable row level security;
alter table conversation_context enable row level security;
alter table customer_purchase_intents enable row level security;
alter table identity_resolution_events enable row level security;
