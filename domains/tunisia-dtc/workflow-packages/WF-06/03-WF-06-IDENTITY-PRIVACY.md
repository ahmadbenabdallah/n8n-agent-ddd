# WF-06 Identity, Privacy & Order Scope

## Principle

Customer-provided identifiers are not authorization.

WF-06 consumes the verified identity context from WF-02/WF-03.

Identity graph:

```text
Messenger / channel identity
        ↓
internal customer_id
        ↓
commerce identity
        ↓
WooCommerce customer
        ↓
verified order_scope
```

## Protected support data

Order-specific details require appropriate order scope.

Examples:
- order status
- items
- tracking
- delivery address
- phone
- transaction information

Only minimum necessary fields should reach WF-06/LLM.

## Public channel

Never expose private order data in comments.

Example:

Customer public comment:
“Where is my order? My phone is 20xxxxxx.”

Expected:
- no order lookup result in public response
- no phone repetition
- redirect to private channel

## Identity conflict

If multiple customers/orders could match:
- do not choose arbitrarily
- do not disclose candidates
- request the minimum permitted verification step or escalate

## Scope lifecycle

```text
PENDING
→ ACTIVE
→ REVOKED / EXPIRED
```

Expired/revoked scope cannot authorize protected support reads.

## LLM restriction

The LLM cannot:
- promote identity level
- establish order scope
- select another customer's order
- infer authorization
