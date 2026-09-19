# WF-15 Transaction Contract

Normalized status response:

```json
{
  "success": true,
  "order_id": "123",
  "transaction_status": "NOT_REQUIRED",
  "payment_method": "cod",
  "payment_status": "not_paid",
  "source": "woocommerce",
  "observed_at": "...",
  "correlation_id": "req_123"
}
```

For online payment deployments, transaction identifiers must be treated as sensitive and minimized.

Do not expose gateway raw responses to the LLM/customer.
