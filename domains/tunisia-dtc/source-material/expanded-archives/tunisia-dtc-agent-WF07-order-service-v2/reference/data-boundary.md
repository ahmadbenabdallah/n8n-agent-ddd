# WF-07 Data Boundary

## Trusted identity
WF-07 accepts only identity attributes established upstream by the identity/verification flow. A Messenger user ID, phone number typed in chat, screenshot, order number, or name is not by itself an ownership proof.

## WooCommerce transactional truth
Order state is read through WF-20. WF-07 compares the returned order to the trusted owner scope.

## Guest COD orders
Guest orders may have `customer_id=0`. Ownership can therefore be verified against an upstream verified email or verified phone. These values are used only for matching and are not returned to the customer.

## Output minimization
The customer-facing contract contains order number/id, status, dates, item summary, currency/total, shipping method, and an authorized tracking URL when present. Full billing/shipping data and raw WooCommerce metadata are never forwarded.
