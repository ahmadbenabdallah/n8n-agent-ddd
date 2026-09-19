-- Row level security on every domain table, with no policies: deny by default.
-- The application connects as the table owner (or a role with explicit grants),
-- never as a public API role. Provider-specific roles are handled by a profile
-- under platform/state/db/profiles/.
DO $$
DECLARE tbl text;
BEGIN
  FOREACH tbl IN ARRAY ARRAY[
    'customer_identities',
    'conversations',
    'conversation_states',
    'carts',
    'cart_items',
    'order_scopes',
    'commerce_orders',
    'actions',
    'authorizations',
    'execution_operations',
    'transactions',
    'escalations',
    'audit_events',
    'idempotency_keys',
    'knowledge_documents',
    'customer_configurations',
    'customer_extensions',
    'configuration_changes'
  ]
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', tbl);
    EXECUTE format('REVOKE ALL ON TABLE public.%I FROM PUBLIC', tbl);
  END LOOP;
END $$;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM PUBLIC;
--> statement-breakpoint
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
