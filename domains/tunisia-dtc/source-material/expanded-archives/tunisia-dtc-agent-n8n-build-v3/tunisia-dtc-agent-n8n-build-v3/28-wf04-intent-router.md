# WF-04 — Intent Router

## Intent set

```text
product_discovery
product_question
product_comparison
pricing
promotion
availability
shipping
payment
order_status
return_exchange
complaint
safety
payment_dispute
checkout
human_request
off_topic
security_suspicion
```

## Recommended routing

Use deterministic keyword/rule shortcuts for obvious high-risk intents:
- safety;
- chargeback/payment dispute;
- legal;
- human request.

For ambiguous sales/support cases, use a small classification call with strict enum output.

## Output

```json
{
  "intent": "product_discovery",
  "confidence": 0.94,
  "requires_human": false
}
```

Confidence is a routing signal, not authorization.
