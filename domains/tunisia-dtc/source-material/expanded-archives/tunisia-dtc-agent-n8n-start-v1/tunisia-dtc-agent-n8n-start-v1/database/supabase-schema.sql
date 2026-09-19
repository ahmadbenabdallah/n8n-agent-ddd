create extension if not exists vector;
create table if not exists conversation_state (
 conversation_id text primary key, channel text not null, channel_user_id text,
 state jsonb not null default '{}'::jsonb, updated_at timestamptz not null default now()
);
create table if not exists agent_events (
 id bigint generated always as identity primary key, conversation_id text, message_id text,
 event_type text not null, payload jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create unique index if not exists agent_events_message_id_idx
on agent_events(message_id) where message_id is not null;
