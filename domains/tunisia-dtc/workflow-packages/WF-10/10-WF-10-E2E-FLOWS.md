# WF-10 E2E Flows

## Cart add
WF-09 proposes cart_add → WF-10 validates identity/parameters/preconditions → AUTHORIZED → WF-12 → verify → render.

## Order status
WF-09 proposes order_status → WF-10 checks active scope → missing scope = NEEDS_VERIFICATION → valid scope = AUTHORIZED → WF-07 fresh lookup.

## COD checkout
WF-09 proposes checkout_confirm → WF-10 validates checkout context and fresh commerce state → WF-14 creates order → WF-20 verifies → COD remains `not_paid` unless commerce reports otherwise.

## Human takeover race
Proposal arrives → WF-08 changes owner → WF-10 rechecks ownership → HUMAN_REQUIRED → no mutation.

## WooCommerce timeout
Authorized mutation starts → timeout/unknown → no blind retry → reconciliation → verify commerce state before recovery.
