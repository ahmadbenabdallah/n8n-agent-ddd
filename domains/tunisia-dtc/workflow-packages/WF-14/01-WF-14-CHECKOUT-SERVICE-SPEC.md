# WF-14 Checkout Service Specification

## Responsibilities
WF-14:
- prepare checkout from the canonical cart;
- collect/validate required checkout fields;
- revalidate live cart/product/promotion state;
- calculate/obtain authoritative checkout totals from commerce;
- enforce checkout business prerequisites;
- submit an authorized order-creation operation;
- verify the resulting WooCommerce order;
- return normalized checkout/order facts.

## Non-responsibilities
WF-14 does not:
- authorize actions;
- establish identity;
- grant order scope;
- process payment;
- claim payment success from order creation;
- invent price, stock, discount, shipping fee or total;
- call arbitrary commerce endpoints.

WF-10 is the authorization boundary.
WF-20 is the only privileged WooCommerce boundary.
WF-15 owns transaction/payment state.
