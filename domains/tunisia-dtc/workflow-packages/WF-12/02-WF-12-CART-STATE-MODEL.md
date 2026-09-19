# WF-12 Cart State Model

The canonical application state lives in WF-03/Supabase.

A cart context may contain:
- `cart_id`;
- `conversation_id`;
- `customer_id` when known;
- `commerce_identity_id` when available;
- commerce session reference;
- selected product/variation IDs;
- quantities;
- last verified cart snapshot;
- cart version;
- last action ID;
- idempotency key;
- last synchronization timestamp.

Do not treat LLM state suggestions as canonical.

## Cart lifecycle
`ABSENT → ACTIVE → UPDATED → CHECKOUT_READY → CONVERTED | ABANDONED`

Cart state must be re-read from the authoritative commerce layer after mutations.
