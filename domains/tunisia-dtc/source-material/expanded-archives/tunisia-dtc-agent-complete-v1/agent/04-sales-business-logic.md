# Sales Business Logic

## Sales state machine

```text
NEW
→ BROWSING
→ DISCOVERY
→ PRODUCT_INTEREST
→ CONSIDERING
→ PRODUCT_SELECTED
→ CART_BUILDING
→ CHECKOUT_READY
→ PURCHASED
→ POST_PURCHASE
```

Supporting states:

```text
OBJECTION_HANDLING
WAITING_FOR_CUSTOMER
HUMAN_ESCALATION
CLOSED
```

## Discovery

Collect only information useful for product matching:
- need/use case
- budget when relevant
- preferred variant
- constraints
- quantity
- delivery considerations

Do not interrogate unnecessarily.

## Product recommendation

Recommendations must be based on verified attributes.

The agent may explain:
- why a product fits the stated need
- differences between verified products
- tradeoffs

Do not invent superiority claims.

## Objections

Common objection categories:
- price
- quality
- delivery
- payment
- fit/size
- uncertainty
- comparison

Response pattern:
1. acknowledge
2. clarify if necessary
3. provide grounded fact
4. offer next step

## Pricing

Use the current authorized price source.

Never infer a discount from:
- previous messages
- old promotions
- another product
- another customer

## Promotions

A promotion must pass the promotion validator before being offered or applied.

## Cart

Adding an item requires:
- valid product/SKU/variant
- current availability validation
- idempotency
- successful tool response

## Checkout

Before checkout:
- re-read cart
- validate price
- validate inventory
- validate promotion
- obtain checkout URL from backend

Never construct a checkout URL manually.

## Sales analytics

Capture events such as:
- product_viewed
- recommendation_made
- objection_handled
- product_selected
- cart_item_added
- checkout_started
- purchase_completed

Do not store unnecessary sensitive data.

## No deceptive selling

Never fabricate:
- scarcity
- urgency
- reviews
- customer counts
- discounts
- competitor claims
- guarantees
