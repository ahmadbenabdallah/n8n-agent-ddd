# Customer Identity Graph Specification

## 1. Objective
Create a persistent, auditable identity graph connecting channel identity, internal customer_id, commerce identity, WooCommerce customer_id, and verified order scope.

**Identity matching is not authorization.**

## 2. Identity levels
- 0 — ANONYMOUS: channel/session only; general information.
- 1 — CHANNEL_LINKED: trusted channel/session relationship; limited personalization.
- 2 — ORDER_VERIFIED: application-verified customer/order relationship; scoped order information.
- 3 — HIGH_ASSURANCE: additional verification for sensitive actions.

For implementation, `COMMERCE_MATCHED` may be used as a non-privileged graph status between channel linking and order verification.

Recommended progression:
`ANONYMOUS → CHANNEL_LINKED → COMMERCE_MATCHED → ORDER_VERIFIED → HIGH_ASSURANCE`

The LLM cannot promote identity or grant permissions.

## 3. Canonical graph
```text
channel_identities
       |
       v
customers
       |
       v
commerce_identities
       |
       v
WooCommerce customer
       |
       v
customer_order_scope
       |
       v
authorized order(s)
```

## 4. Messenger identity
Use:
- `channel`
- `channel_subject_id` (e.g. Messenger PSID)
- `conversation_id`
- opaque internal `customer_id`

Do not expose platform identifiers to customers.

A first-time Messenger user can be linked to an internal customer record, but that does not authorize access to private commerce data.

## 5. Website-originated orders
Supported flow:
```text
WooCommerce website order
→ Messenger contact
→ channel identity resolves to customer_id
→ bounded candidate discovery
→ application verification
→ active customer_order_scope
→ WF-10 authorization
→ WF-20 fresh WooCommerce lookup
```

A phone number may be used as a discovery/verification input, but is not a universal authentication credential.

Order number, name, phone number, customer claim, or conversation history alone are not sufficient proof.

## 6. Order scope
Example:
```json
{
  "identity_level": 2,
  "order_scope": [{
    "order_id": "10582",
    "permissions": ["read_status", "read_shipping"],
    "verified_at": "2026-09-17T10:00:00Z",
    "expires_at": null
  }]
}
```

Allowlist permissions such as:
- `read_status`
- `read_shipping`
- `read_items_summary`

Never create broad permissions such as `read_any_order`.

Only application logic/WF-10 can authorize access.

## 7. Scope lifecycle
`PENDING → ACTIVE → REVOKED → EXPIRED`

WF-10 fails closed for anything except ACTIVE.

## 8. Multiple candidates
If discovery returns multiple orders:
- do not guess;
- do not disclose all candidate details;
- apply configured verification;
- escalate when ambiguity cannot be safely resolved.

## 9. Identity collision
If one channel identity maps to conflicting customers:
- do not auto-merge;
- mark conflict;
- fail closed for sensitive operations;
- create an audit/security event;
- resolve through application/human process.

## 10. Data minimization
Store opaque IDs, relationship state, verification metadata, timestamps, and audit references only as needed.

Never store passwords, OTPs, card numbers, CVV, API keys, or authentication secrets.

## 11. Authority
Supabase is authoritative for the identity graph, links, scopes, and verification history.

WooCommerce remains authoritative for live order status and current commerce facts.

**Security invariant: a graph relationship is not authorization.**
