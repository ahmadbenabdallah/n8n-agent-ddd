create table if not exists public.agent_audit_events (
  event_id text primary key,
  event_type text not null,
  event_category text not null,
  timestamp timestamptz not null,
  conversation_id uuid,
  channel text not null,
  customer_id uuid references public.customers(id) on delete set null,
  intent text,
  language text,
  script text,
  source_ids jsonb not null default '[]'::jsonb,
  action_id text,
  action_type text,
  authorization_result text,
  security_flags jsonb not null default '[]'::jsonb,
  success boolean,
  metadata jsonb not null default '{}'::jsonb,
  redaction_applied boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_agent_audit_time
on public.agent_audit_events(timestamp desc);

create index if not exists idx_agent_audit_category_time
on public.agent_audit_events(event_category,timestamp desc);

create index if not exists idx_agent_audit_conversation
on public.agent_audit_events(conversation_id,timestamp desc);

create index if not exists idx_agent_audit_action
on public.agent_audit_events(action_id)
where action_id is not null;

alter table public.agent_audit_events enable row level security;
