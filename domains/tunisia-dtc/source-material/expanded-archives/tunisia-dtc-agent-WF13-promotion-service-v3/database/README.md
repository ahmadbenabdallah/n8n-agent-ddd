# Database

WF-13 requires no authoritative coupon table.

Do not mirror WooCommerce coupon validity into Supabase as a transaction source of truth.

Supabase can store:
- conversation/customer context
- purchase intent
- audit metadata such as action ID/result code

It should not become the canonical coupon ledger.
