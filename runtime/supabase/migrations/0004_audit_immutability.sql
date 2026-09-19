create or replace function public.prevent_audit_mutation() returns trigger language plpgsql security invoker as $$ begin raise exception 'audit_events_are_append_only'; end; $$;
drop trigger if exists audit_events_immutable on public.audit_events;
create trigger audit_events_immutable before update or delete on public.audit_events for each row execute function public.prevent_audit_mutation();
revoke all on function public.prevent_audit_mutation() from public, anon, authenticated;
