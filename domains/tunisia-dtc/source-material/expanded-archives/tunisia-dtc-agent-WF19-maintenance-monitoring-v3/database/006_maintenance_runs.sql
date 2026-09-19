create table if not exists public.agent_maintenance_runs (
  run_id text primary key,
  operation text not null,
  scope text not null,
  operational_state text not null
    check(operational_state in ('healthy','degraded','pending','unknown')),
  results jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_maintenance_runs_time
on public.agent_maintenance_runs(created_at desc);

alter table public.agent_maintenance_runs enable row level security;
