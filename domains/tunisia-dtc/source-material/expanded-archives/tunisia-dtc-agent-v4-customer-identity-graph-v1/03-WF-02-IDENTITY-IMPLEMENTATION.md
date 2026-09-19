# WF-02 Identity Implementation

WF-02 resolves identity context. It does not authorize protected commerce actions.

## Input
```json
{
  "conversation_id": "conv_123",
  "channel": "facebook",
  "channel_subject_id": "PSID",
  "requested_intent": "order_status"
}
```

## Output
```json
{
  "customer_id": "cust_uuid",
  "identity_level": 1,
  "channel_identity_status": "active",
  "commerce_identity": {
    "provider": "woocommerce",
    "customer_id": null,
    "status": "candidate"
  },
  "active_order_scope_ids": [],
  "verification_required": true,
  "identity_conflict": false
}
```

## Rules
1. Resolve `(channel, channel_subject_id)` to one active channel identity.
2. If none exists, create/link an internal customer according to application policy.
3. Conflicting mappings fail closed.
4. Load commerce identity relationships.
5. Load only the scope metadata needed by authorization.
6. Never upgrade identity from LLM output.
7. Never treat customer claims as proof.
8. Do not send the full identity graph to the LLM.

For website-originated orders, route bounded discovery to WF-07; verification establishes scope; then WF-10 authorizes future protected reads.
