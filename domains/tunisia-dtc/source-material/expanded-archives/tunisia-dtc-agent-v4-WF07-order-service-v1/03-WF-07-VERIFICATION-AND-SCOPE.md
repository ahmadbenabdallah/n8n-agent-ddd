# WF-07 Verification and Scope Flow

## Website order → Messenger

```text
Messenger PSID
   ↓
WF-02 customer_id
   ↓
No active order scope
   ↓
WF-07 requests minimum verification input
   ↓
WF-20 bounded candidate discovery
   ↓
candidate(s)
   ↓
application verification
   ↓
identity_verification_events
   ↓
customer_order_scope ACTIVE
   ↓
WF-10 authorization
   ↓
WF-20 fresh order read
```

## Single candidate

A single candidate is not automatically equivalent to authorization unless the configured verification policy explicitly establishes the relationship.

## Multiple candidates

Multiple candidates remain ambiguous until verification resolves the relationship.

Do not disclose:
- candidate order numbers;
- totals;
- addresses;
- item details;
- status of unrelated orders.

## Scope persistence

After successful verification, persist:
- internal customer_id;
- WooCommerce customer ID when verified;
- order ID;
- explicit permissions;
- verification method;
- verified_at;
- expiry/revocation state.

Future access uses the stored scope without unnecessarily repeating verification, while WF-10 continues to revalidate it.
