# WF-14 E2E Flows

## Normal COD checkout
Cart ready
→ customer confirms
→ WF-10 authorizes
→ fresh preflight
→ WooCommerce creates COD order
→ WF-14 verifies order
→ payment remains not_paid
→ WF-16 renders verified order confirmation.

## Price changed
Preflight detects price change
→ order creation stops
→ customer receives updated verified checkout information
→ new confirmation/authorization required where policy requires.

## Stock changed
→ order creation stops
→ no false success.

## Coupon expired
→ WF-13/WF-20 rejects
→ final total recalculated
→ customer must confirm changed checkout.

## Human takeover
→ ownership changes to HUMAN
→ checkout blocked.

## Timeout
→ UNKNOWN_EXECUTION
→ reconciliation
→ if matching order found, verify it;
→ otherwise recovery/human path.
