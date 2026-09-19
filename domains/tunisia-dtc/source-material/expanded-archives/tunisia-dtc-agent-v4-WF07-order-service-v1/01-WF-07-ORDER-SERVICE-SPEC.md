# WF-07 Order Service — Production Specification

## 1. Responsibility

WF-07 is the application order service between conversation orchestration and the WooCommerce gateway.

It handles:
- order discovery;
- order-scope-aware reads;
- verification workflow coordination;
- order context normalization;
- bounded recovery/reconciliation.

It does not:
- grant permissions;
- invent order data;
- expose unrelated orders;
- directly bypass WF-10;
- directly call WooCommerce outside WF-20.

## 2. Separation of concerns

```text
Discovery
   ↓
Candidate identification
   ↓
Application verification
   ↓
Order scope persistence
   ↓
WF-10 authorization
   ↓
WF-20 WooCommerce read
   ↓
Fresh verified order state
   ↓
WF-16 rendering
```

**Order discovery is not authorization.**

## 3. Supported scenarios

### A. Existing scoped customer
If the customer has an ACTIVE order scope:
1. WF-07 receives the requested order reference.
2. WF-10 validates scope.
3. WF-20 reads the current order.
4. WF-07 normalizes only permitted fields.
5. WF-16 renders the result.

### B. Website-originated order
If the customer contacts Messenger but has no active order scope:
1. WF-07 requests the minimum approved verification input.
2. WF-20 performs a bounded candidate lookup.
3. WF-07 receives candidate metadata only.
4. Application verification is performed.
5. On success, `customer_order_scope` becomes ACTIVE.
6. WF-10 authorizes the protected read.
7. WF-20 fetches fresh order state.
8. WF-16 responds.

### C. Multiple candidate orders
If discovery returns multiple candidates:
- do not guess;
- do not reveal full candidate details;
- do not expose addresses or unrelated order information;
- continue the configured verification flow;
- escalate if ambiguity cannot be safely resolved.

## 4. Candidate discovery contract

Input:
```json
{
  "customer_id": "cust_uuid",
  "channel": "facebook",
  "discovery_type": "phone",
  "discovery_value_ref": "server-side-reference"
}
```

Output:
```json
{
  "status": "CANDIDATE",
  "candidate_count": 1,
  "candidate_refs": ["opaque_candidate_ref"],
  "verification_required": true
}
```

Do not pass raw discovery values into LLM context unless strictly required and approved. Prefer server-side references.

## 5. Verification

Verification is application-controlled.

A phone number, order number, name, or customer claim alone must not automatically establish ownership.

Verification should produce:
- verification event;
- verified customer/order relationship;
- scope permissions;
- verification timestamp;
- optional expiry policy.

The resulting scope is then persisted in Supabase.

## 6. Order scope

Example:
```json
{
  "order_id": "10582",
  "permissions": [
    "read_status",
    "read_shipping"
  ]
}
```

The LLM cannot create or modify this scope.

WF-10 decides whether the scope authorizes the requested operation.

## 7. Live order authority

Supabase identity/order scope authorizes access.

WooCommerce is authoritative for current:
- order status;
- fulfillment/shipping state;
- line-item/order data;
- payment status;
- current order totals where applicable.

Never answer an order-status question solely from cached conversation state.

## 8. Minimum field policy

Typical safe fields:
- order reference;
- status;
- shipping summary;
- item summary if permitted;
- order date where permitted;
- total where policy permits.

Never expose:
- payment credentials;
- internal notes;
- fraud scores;
- supplier information;
- unrelated customer records;
- hidden metadata;
- raw WooCommerce API errors.

## 9. Order mutations

Any supported order mutation must use:
- explicit action contract;
- WF-10 authorization;
- idempotency;
- WF-20 execution;
- post-action verification;
- recovery if execution status is UNKNOWN.

WF-07 cannot infer success from request acceptance or timeout.

## 10. Human ownership

If a human owns the conversation:
- related order requests remain under human ownership;
- conflicting automated consequential actions are blocked by WF-10;
- safe acknowledgement/routing may occur according to policy;
- human release is required before full automation resumes.

## 11. Failure states

Use machine-readable outcomes:
- `NOT_FOUND`
- `CANDIDATE`
- `AMBIGUOUS`
- `VERIFICATION_REQUIRED`
- `VERIFICATION_FAILED`
- `UNAUTHORIZED`
- `SCOPE_EXPIRED`
- `SCOPE_REVOKED`
- `IDENTITY_CONFLICT`
- `COMMERCE_UNAVAILABLE`
- `UNKNOWN_EXECUTION`
- `RECONCILIATION_REQUIRED`

Never translate a failure/unknown state into a successful customer claim.

## 12. Privacy

For public comments:
- never expose order details;
- redirect to private conversation.

For private Messenger:
- return only fields authorized by scope and policy.
