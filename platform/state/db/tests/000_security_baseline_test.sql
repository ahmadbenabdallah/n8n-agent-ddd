-- pgTAP: provider-neutral security baseline. Run against any Postgres.
begin;
select plan(21);

select ok((select relrowsecurity from pg_class where oid = 'public.customer_identities'::regclass), 'RLS customer_identities');
select ok((select relrowsecurity from pg_class where oid = 'public.conversations'::regclass), 'RLS conversations');
select ok((select relrowsecurity from pg_class where oid = 'public.conversation_states'::regclass), 'RLS conversation_states');
select ok((select relrowsecurity from pg_class where oid = 'public.carts'::regclass), 'RLS carts');
select ok((select relrowsecurity from pg_class where oid = 'public.cart_items'::regclass), 'RLS cart_items');
select ok((select relrowsecurity from pg_class where oid = 'public.order_scopes'::regclass), 'RLS order_scopes');
select ok((select relrowsecurity from pg_class where oid = 'public.commerce_orders'::regclass), 'RLS commerce_orders');
select ok((select relrowsecurity from pg_class where oid = 'public.actions'::regclass), 'RLS actions');
select ok((select relrowsecurity from pg_class where oid = 'public.authorizations'::regclass), 'RLS authorizations');
select ok((select relrowsecurity from pg_class where oid = 'public.execution_operations'::regclass), 'RLS execution_operations');
select ok((select relrowsecurity from pg_class where oid = 'public.transactions'::regclass), 'RLS transactions');
select ok((select relrowsecurity from pg_class where oid = 'public.escalations'::regclass), 'RLS escalations');
select ok((select relrowsecurity from pg_class where oid = 'public.audit_events'::regclass), 'RLS audit_events');
select ok((select relrowsecurity from pg_class where oid = 'public.idempotency_keys'::regclass), 'RLS idempotency_keys');
select ok((select relrowsecurity from pg_class where oid = 'public.knowledge_documents'::regclass), 'RLS knowledge_documents');
select ok((select relrowsecurity from pg_class where oid = 'public.customer_configurations'::regclass), 'RLS customer_configurations');
select ok((select relrowsecurity from pg_class where oid = 'public.customer_extensions'::regclass), 'RLS customer_extensions');
select ok((select relrowsecurity from pg_class where oid = 'public.configuration_changes'::regclass), 'RLS configuration_changes');

select has_trigger('public', 'audit_events', 'audit_events_immutable', 'audit table has the immutability trigger');
select has_function('private', 'reserve_idempotency', 'private.reserve_idempotency exists');
select ok((select has_function_privilege('public', 'private.reserve_idempotency(text,text,text)', 'execute') is false), 'PUBLIC cannot execute reserve_idempotency');

select * from finish();
rollback;
