# Tunisia DTC Agent — WF-02 + WF-03 + Supabase v4

Implements persistent Messenger identity and durable customer/conversation context.

**Supabase = persistent identity/context. WooCommerce = live transactional truth. KB = stable/informational fallback. n8n = control plane.**

Included:
- WF-02 identity v4
- WF-03 context v4
- Supabase/Postgres migration
- JSON contracts
- wiring/security/runbooks
- regression tests

Status: integration-ready implementation scaffold. It still requires the merchant's Supabase project, n8n credentials, exact n8n-version parameter verification, Meta webhook wiring, and staging/E2E/security testing. No secrets are embedded.
