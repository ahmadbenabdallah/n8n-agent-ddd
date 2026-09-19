-- Tunisia DTC Agent — core Supabase schema
create extension if not exists vector;

create table if not exists conversations (
  conversation_id text primary key,
  channel text not null,
  channel_user_id text,
  page_id text,
  state jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists conversation_messages (
  message_id text primary key,
  conversation_id text not null references conversations(conversation_id) on delete cascade,
  direction text not null check (direction in ('inbound','outbound')),
  text text,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists agent_events (
  id bigint generated always as identity primary key,
  conversation_id text,
  message_id text,
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists idempotency_keys (
  idempotency_key text primary key,
  conversation_id text,
  message_id text,
  status text not null default 'received',
  result jsonb,
  created_at timestamptz not null default now(),
  expires_at timestamptz
);
