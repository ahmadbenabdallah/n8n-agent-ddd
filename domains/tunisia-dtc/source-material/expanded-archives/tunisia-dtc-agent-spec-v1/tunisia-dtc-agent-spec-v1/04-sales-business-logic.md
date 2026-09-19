# DTC Sales Business Logic

## Sales state machine

``` text
NEW
 ↓
BROWSING
 ↓
DISCOVERY
 ↓
PRODUCT_INTEREST
 ↓
CONSIDERING
 ↓
PRODUCT_SELECTED
 ↓
CART_BUILDING
 ↓
CHECKOUT_READY
 ↓
PURCHASED
 ↓
POST_PURCHASE
```

Alternative states: - OBJECTION_HANDLING - WAITING_FOR_CUSTOMER -
HUMAN_ESCALATION - CLOSED

## Discovery

Collect only information useful to the purchase: - use case; -
category; - budget; - size; - color; - material preference; -
constraints; - delivery requirement.

Do not interrogate the customer. One or two questions at a time.

## Recommendation

Candidate products must come from the catalog/search layer.

Recommendation reasons must reference actual product attributes.

Never invent: - benefits; - availability; - reviews; - popularity; -
discounts; - urgency.

## Objection handling

Common objections: - price; - quality; - size/fit; - delivery; - return
policy; - payment; - comparison.

Flow: 1. acknowledge; 2. retrieve factual answer; 3. explain; 4. offer
next step.

## Pricing

Price comes from the current authorized pricing source.

LLM must never calculate or invent final prices unless a deterministic
pricing tool returned the calculation.

## Promotions

Promotion validator owns: - code validity; - dates; - minimum basket; -
eligible SKUs; - customer eligibility; - stacking rules; - usage limits.

The model may communicate validated promotions only.

## Cart

Actions must be idempotent.

Before adding: - validate SKU/variant; - validate current
availability; - validate price snapshot if required.

## Checkout

The agent may provide an official checkout URL returned by the commerce
platform.

It must never manufacture a URL.

## Cross-sell / upsell

Only recommend complementary or alternative products explicitly defined
by catalog/business rules.

Avoid manipulative pressure.

## Conversion events

Record: - product_recommended; - product_selected; - add_to_cart; -
promotion_applied; - checkout_started; - purchase_completed; -
purchase_assisted_by_agent.
