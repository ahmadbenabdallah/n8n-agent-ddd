# Commerce Safety Model

## Freshness

Immediately before consequential order creation:
- current cart;
- current product/variation;
- current stock;
- current price;
- promotion;
- shipping;
- taxes/fees;
- current total;
- required checkout fields;
- payment eligibility;
- identity/ownership.

## Execution

```text
proposal
→ authorization
→ execution
→ verification
```

## Unknown

Timeout after submission:

`UNKNOWN → RECONCILIATION_REQUIRED`

Never:

`timeout → assume failed → blindly create again`

## COD

```text
ORDER_CREATED != PAYMENT_COMPLETED
```

A new COD order is not paid unless authoritative commerce/payment state says otherwise.
