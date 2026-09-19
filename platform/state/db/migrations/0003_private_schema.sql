-- Private schema for security-definer helpers that must never be callable by
-- an API role. reserve_idempotency() is the durable idempotency gate: the first
-- caller for a key creates it, later callers get the existing status, and a
-- different request hash for the same key raises idempotency_key_conflict.
CREATE SCHEMA IF NOT EXISTS private;
--> statement-breakpoint
REVOKE ALL ON SCHEMA private FROM PUBLIC;
--> statement-breakpoint
CREATE OR REPLACE FUNCTION private.reserve_idempotency(p_key text, p_operation text, p_request_hash text)
RETURNS TABLE(status text, existing_result jsonb)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE s text; r jsonb;
BEGIN
  SELECT i.status,
         CASE WHEN i.result_reference IS NULL THEN NULL
              ELSE jsonb_build_object('result_reference', i.result_reference) END
    INTO s, r
    FROM public.idempotency_keys i
   WHERE i.key = p_key
     FOR UPDATE;

  IF s IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM public.idempotency_keys i
                WHERE i.key = p_key AND i.request_hash <> p_request_hash) THEN
      RAISE EXCEPTION 'idempotency_key_conflict';
    END IF;
    RETURN QUERY SELECT s, r;
    RETURN;
  END IF;

  INSERT INTO public.idempotency_keys(key, operation, request_hash, status)
  VALUES (p_key, p_operation, p_request_hash, 'IN_PROGRESS');
  RETURN QUERY SELECT 'CREATED'::text, NULL::jsonb;
END; $$;
--> statement-breakpoint
REVOKE EXECUTE ON FUNCTION private.reserve_idempotency(text, text, text) FROM PUBLIC;
