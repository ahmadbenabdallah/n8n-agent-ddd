# Supabase provider profile

Postgres holds the durable domain state; n8n execution history is transient. The commerce platform remains the source of truth for commerce data.

Supabase is **one supported Postgres provider**, not a requirement. Any Postgres works (Neon, RDS, self-hosted).

- **Migrations** live in `platform/state/db/migrations/` and are provider-neutral. Apply them with `pnpm db:migrate`.
- **Supabase-only statements** (revoking access from the `anon` and `authenticated` Data API roles) live in `platform/state/db/profiles/supabase/`, applied only when `DATABASE_PROFILE=supabase`.
- **Verify a migration run** against a real Postgres with `pnpm db:verify` (requires Docker).

`migrations/` in this folder is the previous Supabase-only tree, kept until the new tree is verified against it, then removed.

Never store API keys, OAuth tokens, payment credentials, card numbers, CVV, OTP, PIN, cart tokens or nonces in domain tables.

Schema changes follow expand → migrate and backfill → contract.
