-- WF-07 audit extension. Store event metadata, not raw customer messages or Woo secrets.
create table if not exists order_service_audit (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  conversation_id text,
  message_id text,
  operation text not null,
  order_id text,
  identity_level text,
  owner_match boolean,
  verified_source boolean,
  outcome text not null,
  reason text,
  latency_ms integer
);
create index if not exists idx_order_service_audit_order on order_service_audit(order_id);
create index if not exists idx_order_service_audit_created on order_service_audit(created_at);
