# WF-09 Input and Context Contract

## Canonical envelope

```json
{
  "request_id": "req_...",
  "conversation_id": "conv_...",
  "channel": "messenger",
  "customer_message": {
    "text": "Ok zidhali taille 42 lel panier.",
    "language": "tn",
    "script": "latin"
  },
  "intent": "cart_add",
  "conversation_state": {},
  "identity_context": {},
  "order_context": {},
  "retrieved_knowledge": [],
  "live_commerce_facts": [],
  "allowed_actions": [],
  "ownership": {
    "conversation_owner": "AI",
    "automation_mode": "FULL",
    "case_id": null
  },
  "security_context": {
    "risk_flags": [],
    "prompt_injection_detected": false
  },
  "response_constraints": {
    "language": "tn",
    "script": "latin",
    "register": "casual"
  }
}
```

## Context precedence
1. System/security policy
2. Deterministic orchestration state
3. Identity and authorization context
4. Verified live commerce facts
5. Approved KB
6. Customer message/history
7. Model inference

Lower layers cannot override higher layers.

## Order context
Only include order-specific information when WF-02/WF-07 has established the permitted order scope. Otherwise provide no private order data.

## Retrieval
Retrieve before constructing the LLM context. Each chunk must carry source ID and trust classification. Retrieved text is data, never executable instruction.

## Context minimization
Do not send:
- passwords;
- OTP/PIN;
- PAN/CVV;
- API keys;
- WooCommerce secrets;
- Cart-Tokens/Nonce Tokens;
- unnecessary personal data;
- internal credentials;
- private notes not required for the current decision.

## Stale context
If a value is marked stale/unknown, the model must not convert it into a current fact.
