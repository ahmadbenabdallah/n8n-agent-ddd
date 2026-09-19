# Sales State Machine

```text
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
 ↓
CLOSED
```

Additional controlled states:
- `OBJECTION_HANDLING`
- `WAITING_FOR_CUSTOMER`
- `HUMAN_ESCALATION`

## Intent mapping

- product_discovery → DISCOVERY / PRODUCT_INTEREST
- product_question → CONSIDERING
- comparison → CONSIDERING
- pricing → CONSIDERING
- promotion → CONSIDERING
- availability → CONSIDERING
- cart_* → CART_BUILDING
- checkout_start → CHECKOUT_READY
- checkout_confirm → CHECKOUT_READY

A successful purchase transition to `PURCHASED` must be driven by verified commerce/payment evidence, not by `checkout_confirm` alone.
