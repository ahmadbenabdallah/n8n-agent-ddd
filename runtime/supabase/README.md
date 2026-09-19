# Supabase Durable Domain State

Phase 7 establishes durable PostgreSQL state for the Tunisia DTC domain.
Supabase is the source of truth for application/domain state; n8n execution
history is transient. WooCommerce remains the commerce source of truth.

Never store API keys, OAuth tokens, payment credentials, PAN/CVV/OTP/PIN,
cart tokens or nonce tokens in domain tables.

Schema changes should use `expand → migrate/backfill → contract`.
