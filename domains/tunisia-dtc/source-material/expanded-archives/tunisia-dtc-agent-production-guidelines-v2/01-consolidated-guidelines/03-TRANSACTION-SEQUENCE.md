# Transaction Sequence

## Cart

WF-12
→ WF-11 live product/stock validation
→ WF-20 Store API
→ post-action cart verification

## Promotion

WF-13
→ WF-20 coupon validation
→ WooCommerce current coupon/cart rules

## Checkout

WF-14
→ live cart/product/variation/stock/price/coupon/customer/COD validation
→ verified checkout snapshot

## Order creation

WF-15
→ trusted confirmation
→ authorization
→ fresh transaction preflight
→ WF-20 create COD order
→ retrieve order
→ verify order
→ WF-16 renderer

## Critical semantic rule

`order_created != paid`

For COD:
- order may be created
- payment status remains not paid
- later payment events may change payment/order state

The renderer must not claim payment capture unless a trusted payment source establishes it.
