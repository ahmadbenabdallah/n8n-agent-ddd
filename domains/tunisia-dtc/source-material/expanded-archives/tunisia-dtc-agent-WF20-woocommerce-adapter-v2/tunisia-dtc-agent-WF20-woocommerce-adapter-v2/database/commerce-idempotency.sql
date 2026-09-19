create table if not exists commerce_idempotency (
 id bigserial primary key,
 idempotency_key text not null unique,
 operation text not null,
 request_hash text not null,
 status text not null check(status in ('reserved','succeeded','failed','awaiting_verification')),
 external_resource_type text,
 external_resource_id text,
 response_json jsonb,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists commerce_idempotency_status_idx on commerce_idempotency(status);
create index if not exists commerce_idempotency_operation_idx on commerce_idempotency(operation);
