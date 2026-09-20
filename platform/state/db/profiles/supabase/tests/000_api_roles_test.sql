-- pgTAP: Supabase profile. The Data API roles must have no domain access.
-- Run only on Supabase, where anon and authenticated exist.
begin;
select plan(7);

select ok((select has_table_privilege('anon', 'public.customer_identities', 'select') is false), 'anon cannot select domain state');
select ok((select has_table_privilege('authenticated', 'public.commerce_orders', 'select') is false), 'authenticated cannot select orders');
select ok((select has_table_privilege('authenticated', 'public.audit_events', 'delete') is false), 'authenticated cannot delete audit');
select ok((select has_table_privilege('anon', 'public.transactions', 'select') is false), 'anon cannot read transactions');
select ok((select has_table_privilege('authenticated', 'public.transactions', 'select') is false), 'authenticated cannot read transactions');
select ok((select has_table_privilege('anon', 'public.authorizations', 'select') is false), 'anon cannot read authorizations');
select ok((select has_table_privilege('authenticated', 'public.execution_operations', 'select') is false), 'authenticated cannot read execution state');

select * from finish();
rollback;
