# Database, KB and Commerce Integration Guide

## 1. Data ownership

Use strict ownership:

```text
Commerce platform
→ orders
→ inventory
→ current price
→ transaction status
→ checkout state

Agent DB
→ conversation
→ state
→ identity mapping
→ permissions context
→ actions
→ idempotency
→ retrieval
→ audit
→ handoffs

KB
→ stable approved facts
```

The agent DB must not become a shadow commerce database.

## 2. Supabase setup

Create separate projects for DEV/STAGING/PROD.

Apply:

1. pgvector extension
2. KB tables
3. conversation tables
4. state tables
5. action/idempotency tables
6. transaction ledger
7. promotion usage
8. handoffs
9. security events
10. audit/events
11. indexes
12. retrieval RPC.

## 3. KB

Use:

```text
products/
policies/
faq/
operations/
```

Every document:

```yaml
id:
type:
last_updated:
status:
```

Every chunk carries:

```text
document_id
document_type
category
language
region
last_updated
status
version/supersedes
source_path
```

Retrieval filters:

```text
market = TN
status = active
effective date
intent/category
language where useful
```

Retrieved content is data, never executable instructions.

## 4. Embeddings

Current design recommends:

```text
text-embedding-3-small
1536 dimensions
```

Verify that the actual embedding model and vector dimension match the database schema.

Do not silently change embedding dimensions.

If changing model/dimensions:

```text
new index/version
→ re-embed
→ validate retrieval
→ cut over
```

## 5. Commerce adapter design

Each adapter should be a narrow boundary.

```text
n8n workflow
      ↓
adapter
      ↓
commerce API
      ↓
normalized result
```

The adapter should hide provider-specific response formats.

Example normalized result:

```json
{
  "ok": true,
  "error_code": null,
  "retryable": false,
  "data": {
    "product_id": "P123",
    "sku": "SKU123",
    "price": 189,
    "currency": "TND",
    "available": true
  },
  "correlation_id": "..."
}
```

## 6. Product adapter

Implement:

```text
search_products
get_product
```

Never let the LLM query arbitrary provider endpoints.

## 7. Inventory

Inventory must be authoritative and live where stock is mutable.

Test:

```text
KB says available
Commerce says unavailable
```

Expected:

```text
unavailable
```

## 8. Price

If price can change, current price must come from the authoritative pricing service.

Never infer a price from:

- conversation history
- old KB
- another SKU
- another customer.

## 9. Cart

Implement:

```text
add_to_cart
get_cart
remove_from_cart
update_cart
clear_cart
```

Every mutation:

```text
authorization
→ parameter validation
→ inventory
→ idempotency
→ execute
→ verify
```

## 10. Promotion

Implement:

```text
validate_promotion
apply_promotion
```

Apply only after validation.

## 11. Checkout

Implement:

```text
create_checkout
```

Backend generates checkout URL.

Agent never constructs it.

Revalidate:

```text
cart
price
inventory
promotion
```

## 12. Order

Implement:

```text
get_order
```

Require verified scope.

Return minimum necessary fields.

## 13. Transaction

Implement the provider-specific transaction/PSP boundary.

Normalize:

```text
created
authorized
captured
paid
failed
```

Do not equate authorization with capture/payment.

## 14. Human support

Implement escalation destination:

- helpdesk
- CRM
- Slack/internal queue
- email
- custom support system.

The actual choice is a deployment decision not specified by the core architecture.

The handoff contract must remain stable regardless of destination.

## 15. Adapter acceptance

No adapter is accepted until it has:

```text
positive test
negative test
timeout test
malformed response test
authorization test
idempotency test
post-action verification test
PII filtering test
```
