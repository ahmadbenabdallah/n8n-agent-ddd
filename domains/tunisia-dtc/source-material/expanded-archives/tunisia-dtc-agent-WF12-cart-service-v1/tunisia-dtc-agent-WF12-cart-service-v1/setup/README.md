# WF-12 — Cart Service v1

This workflow is the transactional cart boundary behind WF-10 Action Validator.

## Responsibility

Implements the deterministic service boundary for:
- `cart_view`
- `cart_add`
- `cart_remove`
- `cart_update`
- `cart_clear`

It does **not** decide intent, generate customer copy, or authorize based on LLM output.

Architecture:

`WF-10 Authorized Action Contract → WF-12 Cart Service → commerce adapter → post-action verification`

The LLM never executes a cart mutation.

## Important

The included workflow intentionally uses a **commerce adapter contract** rather than pretending a specific commerce platform exists. Connect the `COMMERCE_CART_ADAPTER` request to the real store API/database before production.

A missing adapter result is returned as `awaiting_adapter`; the workflow never claims success.

## Import

1. n8n → Workflows → Import from File.
2. Import `workflow/WF-12-cart-service.json`.
3. Keep the workflow inactive until the adapter and tests are configured.
4. Invoke it from WF-10 using Execute Workflow.

## Expected input

See `reference/cart-service-contract.json`.

Minimum trusted inputs:
- `authorized_action.execution_allowed=true`
- `authorized_action.action`
- `authorized_action.parameters`
- `authorized_action.idempotency_key`
- `identity.identity_level`
- `cart_context`
- canonical identifiers from the orchestration layer

Customer text must not be used as authorization truth.

## Output

The final node returns a compact service contract:
- service
- status
- action
- execution_allowed
- verification_status
- idempotency_key
- sanitized cart result

## Production adapter

Replace the placeholder adapter boundary with a real HTTP/API or database adapter that:
- accepts only the validated request
- uses server-side credentials
- enforces cart ownership
- performs atomic mutation where supported
- returns a stable cart version
- returns verified owner/cart identifiers
- supports idempotency
- never returns payment secrets or unnecessary PII

## Cart mutation semantics

`cart_add`: add SKU + variant + quantity.

`cart_remove`: remove a specific cart line/variant.

`cart_update`: replace quantity and/or variant only when explicitly authorized by the action parameters.

`cart_clear`: clear all lines.

`cart_view`: read the current cart.

Stock is checked before add/update when live stock is available. The commerce adapter remains the final source of truth for concurrency-sensitive stock.
