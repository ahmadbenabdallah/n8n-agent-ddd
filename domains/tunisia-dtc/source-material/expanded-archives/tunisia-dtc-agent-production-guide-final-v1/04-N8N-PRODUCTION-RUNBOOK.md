# n8n Production Runbook

## 1. Workflow conventions

Every workflow must use:
- deterministic workflow name: `DTC-WF-XX-<name>`
- explicit version in documentation
- correlation ID
- action ID for mutations
- normalized result envelope
- bounded error codes
- no secrets in Code node literals
- no arbitrary URLs supplied by model/customer data
- least-privilege credentials
- explicit timeout and failure path

## 2. Sub-workflow boundaries

Use n8n Execute Workflow for internal workflow calls where appropriate.

Never expose a privileged workflow as a generic public webhook.

WF-20 should accept an allowlisted operation such as:
`get_product`, `get_products`, `get_variation`, `get_order`, `create_cod_order`, `update_order_status`, `coupon_validate`, `cart_view`, `cart_add`, `cart_remove`, `cart_update`, `cart_clear`, `checkout_validate`, `transaction_preflight`, `health`.

Reject unknown operations before any HTTP/node execution.

## 3. Error envelope

```json
{
  "ok": false,
  "error": {
    "code": "COMMERCE_UNAVAILABLE",
    "retryable": true,
    "customer_safe": true
  },
  "correlation_id": "...",
  "action_id": "..."
}
```

Internal diagnostics are not customer-visible.

## 4. Credentials

Store:
- OpenAI credential
- Supabase credential
- WooCommerce credential
- Meta credential
- alerting/support credentials

only in n8n credential storage or the deployment secret manager.

Never put secrets in:
- workflow JSON
- Code nodes
- environment files committed to Git
- prompt text
- audit metadata
- customer messages

## 5. Production n8n controls

- Separate staging and production credentials.
- Restrict editor/admin access.
- Enable backups of n8n configuration/workflows/credentials according to the deployment model.
- Pin dependency versions where applicable.
- Review community nodes before installation.
- Avoid unnecessary community nodes.
- Set execution data retention deliberately; do not retain sensitive execution payloads longer than required.
- Use queue mode/workers when scale requires it, but preserve idempotency across workers.
- Monitor failed executions and latency.

## 6. Deployment order

1. Database migrations.
2. Supabase functions/RPCs.
3. WF-20.
4. WF-11/12/13/14/15.
5. WF-10.
6. WF-16/17.
7. WF-18/19.
8. WF-09.
9. WF-04/05/06/07/08.
10. WF-01/02/03.
11. WF-00.
12. Meta webhook/channel activation.

Never activate inbound production traffic before the downstream mutation path has passed its production gates.
