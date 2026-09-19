# WF-05 End-to-End Sales Flows

## Flow A — Product discovery

Customer:
“nheb haja behya lel sport.”

1. WF-04 → `product_discovery`
2. WF-05 → `DISCOVERY`
3. WF-05 identifies missing product-matching facts.
4. WF-11 retrieves bounded verified candidates.
5. LLM explains fit using returned facts.
6. WF-16 validates response language/script.
7. State advances only through allowlisted transition.

No purchase action.

## Flow B — Product selection → cart

Customer:
“Ok hedhi behya, zidhali taille 42 lel panier.”

1. WF-04 → `cart_add`/`cart_update`
2. WF-05 sees `PRODUCT_SELECTED` context.
3. WF-11 verifies SKU/variant/current availability.
4. LLM proposes structured cart action.
5. WF-10 validates identity/session, action, parameters, idempotency and business rules.
6. WF-12 executes.
7. WF-12 returns authoritative cart state.
8. WF-03 persists `CART_BUILDING`.
9. WF-16 renders only verified result.

## Flow C — Promotion

Customer:
“3andi code SAVE20, ynajem yekhdem?”

1. WF-04 → `promotion`
2. WF-05 → WF-13
3. WF-13 validates code and eligibility.
4. Result is returned.
5. LLM explains only validated outcome.
6. No promotion is applied merely because the customer supplied the code.

## Flow D — Checkout

Customer:
“Ok nheb nchri taw.”

1. WF-05 determines whether this is checkout start or explicit confirmation based on current state and wording.
2. WF-14 performs fresh cart/price/inventory/promotion validation.
3. WF-10 authorizes any consequential action.
4. WF-14/WF-20 generates authoritative checkout information.
5. Renderer returns verified result.

WF-05 never constructs the URL and never treats conversation history as a checkout snapshot.

## Flow E — Human-owned conversation

State:

```json
{
  "conversation_owner": "HUMAN",
  "automation_mode": "PAUSED",
  "case_id": "case_123"
}
```

Customer sends a new related message.

WF-05:
- does not independently advance the sales transaction
- routes/acknowledges according to human-case policy
- does not create conflicting cart/checkout actions

## Flow F — Commerce outage

Customer asks for current price.

WF-05 → WF-11 → commerce unavailable.

WF-05:
- does not reuse an untrusted old price as current
- returns safe unavailable/retry path
- can trigger escalation based on operational policy

## Flow G — Website-originated customer

Customer says:
“commande mte3i elli 3maltha mel site win wslet?”

WF-05 should not attempt order lookup itself.

Route to WF-07.
WF-07 uses identity/order-scope logic.
Only verified order facts return to sales/support response.

## Flow H — Repeated objection

Customer repeatedly says price is too high.

WF-05:
1. enters `OBJECTION_HANDLING`
2. acknowledges
3. provides verified value/tradeoff
4. offers alternative if factual
5. detects repetition
6. changes strategy or offers human support

No fabricated discount.
