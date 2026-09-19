# Fact Binding Contract

WF-16 accepts only typed facts with provenance.

Example:

```json
{
  "fact_id": "fact_price_123",
  "fact_type": "CURRENT_PRODUCT_PRICE",
  "value": "129.900",
  "currency": "TND",
  "source": "woocommerce",
  "verified_at": "2026-09-17T02:10:00Z",
  "freshness_deadline": "2026-09-17T02:15:00Z"
}
```

Supported fact classes include:
- CURRENT_PRODUCT_PRICE
- CURRENT_STOCK
- PRODUCT_VARIATION
- CART_TOTAL
- CART_LINE
- PROMOTION_VALIDITY
- CHECKOUT_TOTAL
- SHIPPING_FEE
- ORDER_STATUS
- PAYMENT_STATUS
- ORDER_CREATED
- HUMAN_CASE_CREATED
- HUMAN_OWNERSHIP
- RECONCILIATION_STATUS

A fact is renderable only when:
1. provenance exists;
2. verification succeeded;
3. freshness requirements are satisfied for that fact type;
4. identity/order scope permits disclosure;
5. the fact is not marked sensitive/internal.

Never accept a plain LLM statement such as `price=129.9` as a verified fact.
