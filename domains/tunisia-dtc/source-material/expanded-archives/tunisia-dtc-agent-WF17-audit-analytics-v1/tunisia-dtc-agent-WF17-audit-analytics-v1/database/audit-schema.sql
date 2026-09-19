create table if not exists agent_audit_events (
  id bigserial primary key,
  event_id text not null unique,
  event_type text not null,
  occurred_at timestamptz not null default now(),
  trace_id text,
  conversation_id text,
  message_id text,
  channel text,
  actor_ref text,
  intent text,
  stage text,
  decision text,
  status text,
  action text,
  execution_allowed boolean not null default false,
  verification_status text,
  escalation jsonb,
  error_code text,
  latency_ms integer,
  model text,
  workflow text,
  metadata jsonb not null default '{}'::jsonb,
  fingerprint text,
  previous_fingerprint text
);

create index if not exists idx_agent_audit_trace on agent_audit_events(trace_id);
create index if not exists idx_agent_audit_conversation on agent_audit_events(conversation_id);
create index if not exists idx_agent_audit_type_time on agent_audit_events(event_type, occurred_at);

-- Production hardening:
-- grant INSERT to the workflow writer role;
-- restrict UPDATE/DELETE;
-- expose analytics through read-only views;
-- never grant customer-facing workflows unrestricted audit access.
