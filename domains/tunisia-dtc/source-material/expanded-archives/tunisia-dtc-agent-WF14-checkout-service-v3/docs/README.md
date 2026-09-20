# WF-14 Checkout Service v3

WF-14 creates a **verified checkout snapshot**. It does not create the WooCommerce order.

## Responsibilities

- confirm customer/identity context is available;
- require upstream authorization;
- resolve the live WooCommerce cart through WF-20;
- revalidate current products/variations;
- revalidate stock and purchasability;
- revalidate current prices;
- revalidate coupon/promotion;
- verify shipping/checkout constraints available to the store;
- calculate/verify the live checkout total;
- return a short-lived verified snapshot for WF-15.

## COD

The payment method is `cod`.

A checkout snapshot does not mean:
- order created;
- payment completed;
- payment received.

Order creation belongs exclusively to WF-15.
