-- Supabase profile: revoke domain access from the Data API roles.
-- Applied only when DATABASE_PROFILE=supabase, because anon and authenticated
-- exist only on Supabase. The generic migrations already deny PUBLIC.
DO $$
DECLARE tbl text; role_name text;
BEGIN
  FOREACH role_name IN ARRAY ARRAY['anon', 'authenticated'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = role_name) THEN
      RAISE EXCEPTION 'role % does not exist: this profile is for Supabase', role_name;
    END IF;

    FOREACH tbl IN ARRAY ARRAY[
      'customer_identities', 'conversations', 'conversation_states', 'carts', 'cart_items',
      'order_scopes', 'commerce_orders', 'actions', 'authorizations', 'execution_operations',
      'transactions', 'escalations', 'audit_events', 'idempotency_keys', 'knowledge_documents',
      'customer_configurations', 'customer_extensions', 'configuration_changes'
    ]
    LOOP
      EXECUTE format('REVOKE ALL ON TABLE public.%I FROM %I', tbl, role_name);
    END LOOP;

    EXECUTE format('REVOKE ALL ON SCHEMA private FROM %I', role_name);
    EXECUTE format('REVOKE EXECUTE ON FUNCTION private.reserve_idempotency(text,text,text) FROM %I', role_name);
    EXECUTE format('REVOKE ALL ON FUNCTION public.prevent_audit_mutation() FROM %I', role_name);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM %I', role_name);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM %I', role_name);
  END LOOP;
END $$;
