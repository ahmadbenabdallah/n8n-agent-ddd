# WF-16 E2E Acceptance

## A. Product question
Verified product facts → natural response → no internal metadata.

## B. Price
Live price fact → exact customer-visible price → currency preserved.

## C. Availability
Live stock/availability → response bound to current fact.

## D. Cart mutation
Verified mutation result → response says what was actually verified.

## E. COD checkout
Order creation verified → response distinguishes order creation from payment.

## F. Payment status
WF-15 verified payment state → exact state rendered.

## G. Website-originated order
Verified order scope → only scoped status/details rendered.

## H. Human request
WF-08 creates/owns case → handoff message → no autonomous mutation.

## I. Unknown execution
Timeout/unknown → reconciliation wording → no false success/failure.

## J. Language/script
Latin/Arabizi input → Latin/Arabizi output unless explicit Arabic-script request.

## K. Privacy
Unverified/other-customer data → no disclosure.

## L. Delivery retry
Messenger failure → channel retry only; no duplicated commerce mutation.

## Acceptance gate

All mandatory security, privacy, claim-integrity, ownership, idempotency and language/script tests must pass before production.
