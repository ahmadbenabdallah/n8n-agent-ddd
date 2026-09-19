-- Audit is a record, not a working table: no updates, no deletes.
CREATE OR REPLACE FUNCTION public.prevent_audit_mutation() RETURNS trigger
LANGUAGE plpgsql SECURITY INVOKER
AS $$ BEGIN RAISE EXCEPTION 'audit_events_are_append_only'; END; $$;
--> statement-breakpoint
DROP TRIGGER IF EXISTS audit_events_immutable ON public.audit_events;
--> statement-breakpoint
CREATE TRIGGER audit_events_immutable
BEFORE UPDATE OR DELETE ON public.audit_events
FOR EACH ROW EXECUTE FUNCTION public.prevent_audit_mutation();
--> statement-breakpoint
REVOKE ALL ON FUNCTION public.prevent_audit_mutation() FROM PUBLIC;
