# Data Contracts

## Request envelope

```json
{
  "request_id": "uuid",
  "conversation_id": "uuid",
  "channel": "messenger",
  "received_at": "ISO-8601",
  "customer": {
    "channel_user_id": "opaque-reference",
    "customer_id": "internal-id-or-null",
    "identity_level": "ANONYMOUS"
  },
  "message": {
    "message_id": "opaque",
    "text": "customer text"
  },
  "security": {
    "risk_level": "low",
    "flags": []
  }
}
```

## Action proposal

```json
{
  "action_id": "uuid",
  "action_type": "cart_add",
  "parameters": {
    "product_id": "123",
    "quantity": 1,
    "variation_id": "456"
  },
  "reason": "customer requested adding the product",
  "requires_identity_level": "COMMERCE-MATCHED"
}
```

The proposal is untrusted until WF-10 authorizes it.

## Authorization result

```json
{
  "action_id": "uuid",
  "authorization_result": "AUTHORIZED",
  "execution_allowed": true,
  "normalized_action": {},
  "policy_version": "v5"
}
```

Only the authorized branch may produce `execution_allowed=true`.

## Execution result

Use explicit states:
- NOT_EXECUTED
- EXECUTED_VERIFIED
- EXECUTED_FAILED
- EXECUTION_UNKNOWN
- REJECTED

Never tell a customer that an action succeeded when the result is unknown.

## Error model

Errors should be typed:
- VALIDATION_ERROR
- AUTHORIZATION_DENIED
- IDENTITY_REQUIRED
- ORDER_SCOPE_REQUIRED
- NOT_FOUND
- OUT_OF_STOCK
- PRICE_CHANGED
- PROMOTION_INVALID
- CHECKOUT_INVALID
- RATE_LIMITED
- UPSTREAM_TIMEOUT
- EXECUTION_UNKNOWN
- HUMAN_REQUIRED

Do not expose internal stack traces, credentials, URLs, IDs, or security internals to customers.
