create table if not exists agent_monitoring_snapshots (
  id bigserial primary key,
  checked_at timestamptz not null default now(),
  severity text not null check (severity in ('ok','warning','critical')),
  alerts jsonb not null default '[]'::jsonb,
  health jsonb not null default '{}'::jsonb,
  execution_metrics jsonb not null default '{}'::jsonb,
  kb_metrics jsonb not null default '{}'::jsonb,
  anomaly_metrics jsonb not null default '{}'::jsonb
);

create index if not exists idx_monitoring_time
  on agent_monitoring_snapshots(checked_at);

create index if not exists idx_monitoring_severity
  on agent_monitoring_snapshots(severity, checked_at);
