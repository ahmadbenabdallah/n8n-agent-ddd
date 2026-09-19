# Response Normalization

Every WF-20 response should contain typed status:

```json
{
  "operation_id": "order_create",
  "execution_state": "SUCCEEDED",
  "verification_state": "VERIFIED",
  "commerce_source": "woocommerce",
  "commerce_operation_id": "wc_op_123",
  "result": {},
  "error": null,
  "verified_at": "2026-09-17T03:00:00Z"
}
```

Execution states:
`NOT_STARTED | EXECUTING | SUCCEEDED | FAILED | UNKNOWN`

Verification states:
`NOT_REQUIRED | PENDING | VERIFIED | FAILED | RECONCILIATION_REQUIRED`

Never return `success=true` without defined semantics.

For consequential actions, customer-facing success requires verified result, not only HTTP 2xx.
