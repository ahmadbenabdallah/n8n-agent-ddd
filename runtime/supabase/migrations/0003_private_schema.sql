create schema if not exists private;
revoke all on schema private from public, anon, authenticated;
create or replace function private.reserve_idempotency(p_key text,p_operation text,p_request_hash text)
returns table(status text, existing_result jsonb)
language plpgsql security definer set search_path=''
as $$
declare s text; r jsonb;
begin
 select i.status, case when i.result_reference is null then null else jsonb_build_object('result_reference',i.result_reference) end into s,r from public.idempotency_keys i where i.key=p_key for update;
 if s is not null then
   if exists(select 1 from public.idempotency_keys i where i.key=p_key and i.request_hash<>p_request_hash) then raise exception 'idempotency_key_conflict'; end if;
   return query select s,r; return;
 end if;
 insert into public.idempotency_keys(key,operation,request_hash,status) values(p_key,p_operation,p_request_hash,'IN_PROGRESS');
 return query select 'CREATED'::text,null::jsonb;
end; $$;
revoke execute on function private.reserve_idempotency(text,text,text) from public, anon, authenticated;
