# n8n Build Plan — Tunisia DTC Agent v3

## Architecture

The implementation is split into a thin channel-facing parent workflow and reusable sub-workflows.

```text
CHANNEL WEBHOOK
  |
  v
WF-00 INBOUND GATE
  |
  +--> WF-01 SECURITY GATE
  |
  +--> WF-02 IDENTITY
  |
  +--> WF-03 CONVERSATION STATE
  |
  +--> WF-04 INTENT ROUTER
             |
             +--> WF-05 SALES
             +--> WF-06 SUPPORT
             +--> WF-07 ORDER
             +--> WF-08 ESCALATION
  |
  v
WF-09 LLM REASONING
  |
  v
WF-10 ACTION VALIDATOR
  |
  +--> WF-11 PRODUCT
  +--> WF-12 CART
  +--> WF-13 PROMOTION
  +--> WF-14 CHECKOUT
  +--> WF-15 ORDER
  |
  v
WF-16 RESPONSE RENDERER
  |
  v
CHANNEL SEND
  |
  v
WF-17 AUDIT + ANALYTICS
```

## Implementation rules

1. Every workflow receives a `correlation_id`.
2. Every inbound provider message is idempotent.
3. Every write action has an idempotency key.
4. Every tool has a fixed input schema.
5. No workflow executes a tool merely because the LLM named it.
6. All customer/order access is scoped before tool execution.
7. The LLM never receives credentials.
8. Customer-facing errors are sanitized.
9. Security and authorization decisions happen outside the LLM.
10. Use sub-workflows for reusable capabilities rather than one giant agent workflow.

## n8n node conventions

Use names such as:

- `TRIGGER — WhatsApp`
- `NORMALIZE — Inbound`
- `SECURITY — Velocity`
- `IDENTITY — Resolve`
- `STATE — Load`
- `ROUTER — Intent`
- `RAG — Search`
- `LLM — Reason`
- `VALIDATE — Action`
- `TOOL — Product Search`
- `SEND — WhatsApp`
- `AUDIT — Event`

Use `Set/Edit Fields` only for deterministic mapping, `IF/Switch` for deterministic branches, `HTTP Request` for external APIs, and Code nodes only for bounded transformations that cannot be expressed declaratively.

## Error strategy

Every sub-workflow returns:

```json
{
  "ok": true,
  "error_code": null,
  "retryable": false,
  "data": {}
}
```

On failure:

```json
{
  "ok": false,
  "error_code": "UPSTREAM_TIMEOUT",
  "retryable": true,
  "data": null
}
```

Never pass raw upstream errors to the customer.
