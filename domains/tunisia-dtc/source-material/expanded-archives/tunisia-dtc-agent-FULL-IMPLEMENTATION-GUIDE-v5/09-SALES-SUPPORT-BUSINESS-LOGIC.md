# Sales & Support Business Logic

## Sales stages

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
```

## Sales principles

- Answer factual questions before pushing a purchase.
- Never invent product specifications.
- Never invent stock.
- Never invent price.
- Never invent promotion eligibility.
- Do not use deceptive urgency.
- Ask only for information required for the current action.
- Preserve customer language/script preference.

## Cart

Customer intent:
`Ok zidhali taille 42 lel panier.`

Must be interpreted as a cart mutation, not generic checkout.

## Promotion

Promotion decisions must be validated against live rules:
- code;
- amount/type;
- expiry;
- usage restrictions;
- product/category restrictions;
- customer restrictions;
- minimum/maximum order conditions.

## Support

Support may read factual information but protected order information requires order scope.

Mandatory escalation:
- payment dispute;
- chargeback;
- legal threat;
- serious complaint;
- security incident;
- identity uncertainty;
- repeated automation failure;
- explicit human request.
