# WF-15 Authoritative Sources

Payment facts must come from the configured authoritative commerce/payment source.

Depending on deployment:
- WooCommerce order/payment fields;
- a configured payment gateway;
- a controlled transaction provider.

Supabase is orchestration/state storage, not an independent source of truth for whether money was actually received.

Cached/model-generated payment facts are not authoritative.

For COD, WooCommerce order/payment state is used until a separate operational payment event is recorded.
