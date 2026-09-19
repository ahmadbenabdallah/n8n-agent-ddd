# Sales & Business Logic — Production v3

## Sales state machine
NEW → BROWSING → DISCOVERY → PRODUCT_INTEREST → CONSIDERING → PRODUCT_SELECTED → CART_BUILDING → CHECKOUT_READY → PURCHASED → POST_PURCHASE

Supporting states: OBJECTION_HANDLING, WAITING_FOR_CUSTOMER, HUMAN_ESCALATION, CLOSED.

## Discovery
Collect only what is needed: use case, budget, variant, constraints, quantity and delivery considerations.

## Product recommendation
Recommend from verified attributes. Do not invent compatibility, availability or commercial terms.

## Cart
cart_add/cart_update requires product/SKU/variant/quantity, current availability validation, authorization and idempotency. Success requires authoritative tool confirmation.

## Promotion
Promotion is valid only after live validation of code, period, market, product/category restrictions, minimums, eligibility, usage limits and stacking rules.

## Checkout
Reread/reconcile cart immediately before checkout. Revalidate current price, inventory and promotion. Backend generates the checkout URL; the agent never constructs one.

## COD
COD order creation is not payment. Store/order state must preserve `payment_status=not_paid` unless independently verified otherwise.

## Analytics
Record safe events for discovery, recommendation, cart, promotion, checkout, order, escalation and failures without sensitive secrets.
