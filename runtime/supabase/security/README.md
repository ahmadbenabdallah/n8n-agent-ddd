# Supabase Security Model — Phase 7.5

Defense in depth: Postgres grants → RLS → constraints → function privileges → append-only audit → idempotency → WF-10 authorization.

The customer-facing Data API has no direct access to internal domain tables. `service_role` is server-side only. Security-definer functions live in `private`, pin `search_path`, and are not browser-callable. Database tests use pgTAP/Supabase CLI.
