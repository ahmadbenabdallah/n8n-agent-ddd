# WF-20 E2E Acceptance

## A. Product lookup
Authorized lookup → fixed endpoint → normalized current facts.

## B. Variation
Exact variation lookup → verified variation data.

## C. Cart
Authorized Store API/cart operation → token remains internal → post-operation verification.

## D. Promotion
Controlled coupon lookup/validation → no fabricated discount.

## E. Checkout
WF-14 preflight + WF-10 authorization → WF-20 order creation → post-create verification.

## F. COD
Order creation succeeds → payment state is not automatically paid.

## G. Website-originated order
Verified order scope → scoped order lookup only.

## H. Timeout
Unknown execution → no blind retry → authoritative reconciliation.

## I. Human ownership
HUMAN/PAUSED → no normal commerce mutation.

## J. Security
Arbitrary endpoint/credential/header attempts are rejected.

## K. Delivery retry
Messenger delivery retry does not invoke WF-20 again.

All tests must preserve the WF-10 sole-authorization and WF-20 sole-commerce-boundary invariants.
