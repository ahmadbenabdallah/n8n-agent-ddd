# Wiring

WF-11 expects WF-20 v4 to return commerce state.

True branch: `WooCommerce Source-of-Truth Gate` → `Normalize + Verify WooCommerce Product`.
False branch: `KB Informational Fallback`.

For the KB branch, connect the configured Supabase/pgvector retrieval path upstream or replace the fallback node with the merchant's approved retrieval workflow. Do not pass raw credentials, Cart-Tokens, nonces, or secrets into KB/LLM context.
