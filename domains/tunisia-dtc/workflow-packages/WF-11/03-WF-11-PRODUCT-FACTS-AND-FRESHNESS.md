# WF-11 Product Facts and Freshness

## Fact classes

### Stable / descriptive
Examples:
- material;
- dimensions;
- warranty text;
- approved product description;
- category;
- documented features.

These may come from approved KB/product content.

### Dynamic
Examples:
- current price;
- sale price;
- stock status;
- purchasability;
- variation availability;
- current product status.

Dynamic facts must come from live commerce when used for a consequential decision.

## Freshness policy
A cached product result may support general browsing but must not be treated as current for:
- cart mutation;
- checkout;
- quantity-sensitive availability;
- final price statements immediately before purchase.

If required dynamic data is stale or missing:
`FACT_UNAVAILABLE | REVALIDATION_REQUIRED`

WF-11 must never convert an old value into a current claim.
