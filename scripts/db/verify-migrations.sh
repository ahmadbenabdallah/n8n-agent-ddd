#!/usr/bin/env bash
# Verify the Drizzle migration tree on a real Postgres:
#   1. schema parity with the legacy runtime/supabase/migrations tree (if still present)
#   2. the security behaviour we depend on (audit append-only, idempotency gate, RLS)
#   3. pgTAP suites, when the pgtap extension is available
#
# Needs Docker. Usage: bash scripts/db/verify-migrations.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

IMAGE="${POSTGRES_IMAGE:-pgvector/pgvector:pg16}"
NAME="n8n-agent-ddd-verify-$$"
PORT="${POSTGRES_PORT:-55432}"
PSQL="docker exec -i $NAME psql -v ON_ERROR_STOP=1 -U postgres"

cleanup() { docker rm -f "$NAME" >/dev/null 2>&1 || true; }
trap cleanup EXIT

echo "== starting $IMAGE"
docker run -d --name "$NAME" -e POSTGRES_PASSWORD=verify -p "$PORT:5432" "$IMAGE" >/dev/null
for _ in $(seq 1 60); do
  docker exec "$NAME" pg_isready -U postgres >/dev/null 2>&1 && break
  sleep 1
done
docker exec "$NAME" pg_isready -U postgres >/dev/null

$PSQL -c 'create database app' >/dev/null
$PSQL -c 'create database legacy' >/dev/null

echo "== applying drizzle migrations to 'app'"
DATABASE_URL="postgres://postgres:verify@127.0.0.1:$PORT/app" npm_config_engine_strict=false pnpm db:migrate

if compgen -G "runtime/supabase/migrations/*.sql" >/dev/null; then
  echo "== applying legacy runtime/supabase migrations to 'legacy'"
  for f in runtime/supabase/migrations/*.sql; do $PSQL -d legacy -f - < "$f" >/dev/null; done

  echo "== comparing schemas (legacy -> app)"
  # Expected additions in app: the operator tables, the HNSW index and drizzle's own bookkeeping.
  norm() { grep -vE '^(--|SET |SELECT pg_catalog|$)' | sed 's/[[:space:]]\+$//'; }
  docker exec "$NAME" pg_dump -U postgres -s -d legacy | norm > node_modules/.tmp/legacy.sql
  docker exec "$NAME" pg_dump -U postgres -s -d app    | norm > node_modules/.tmp/app.sql
  if diff <(grep -oE 'CREATE TABLE [a-z_.]+' node_modules/.tmp/legacy.sql | sort) \
          <(grep -oE 'CREATE TABLE [a-z_.]+' node_modules/.tmp/app.sql | sort) \
       | grep -E '^<' ; then
    echo "FAIL: tables present in the legacy tree are missing from the drizzle tree" >&2
    exit 1
  fi
  echo "   all legacy tables exist in the drizzle tree; full diff: node_modules/.tmp/{legacy,app}.sql"
fi

echo "== behaviour checks on 'app'"
$PSQL -d app <<'SQL'
-- audit_events is append-only
do $$
declare id uuid;
begin
  insert into public.audit_events(event_type, actor_type, correlation_id)
  values ('test', 'system', 'c1') returning audit_events.id into id;
  begin
    update public.audit_events set event_type = 'changed' where audit_events.id = id;
    raise exception 'FAIL: audit update was allowed';
  exception when sqlstate 'P0001' then
    if sqlerrm <> 'audit_events_are_append_only' then raise; end if;
  end;
  begin
    delete from public.audit_events where audit_events.id = id;
    raise exception 'FAIL: audit delete was allowed';
  exception when sqlstate 'P0001' then
    if sqlerrm <> 'audit_events_are_append_only' then raise; end if;
  end;
end $$;

-- idempotency: first call creates, replay returns the stored status, a different hash conflicts
do $$
declare st text;
begin
  select status into st from private.reserve_idempotency('k1', 'create_order', 'h1');
  if st <> 'CREATED' then raise exception 'FAIL: first reserve returned %', st; end if;

  select status into st from private.reserve_idempotency('k1', 'create_order', 'h1');
  if st <> 'IN_PROGRESS' then raise exception 'FAIL: replay returned %', st; end if;

  begin
    perform private.reserve_idempotency('k1', 'create_order', 'h2');
    raise exception 'FAIL: conflicting request hash was accepted';
  exception when sqlstate 'P0001' then
    if sqlerrm <> 'idempotency_key_conflict' then raise; end if;
  end;
end $$;

-- every domain table has row level security enabled
do $$
declare missing text;
begin
  select string_agg(c.relname, ', ') into missing
    from pg_class c join pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public' and c.relkind = 'r'
     and c.relname <> '__drizzle_migrations' and not c.relrowsecurity;
  if missing is not null then raise exception 'FAIL: RLS missing on %', missing; end if;
end $$;

select 'behaviour checks passed' as result;
SQL

if $PSQL -d app -c 'create extension if not exists pgtap' >/dev/null 2>&1; then
  echo "== pgTAP suites"
  for f in platform/state/db/tests/*.sql; do $PSQL -d app -f - < "$f"; done
else
  echo "== pgTAP not available in $IMAGE; skipped (behaviour checks above cover the same rules)"
fi

echo "VERIFY: PASS"
