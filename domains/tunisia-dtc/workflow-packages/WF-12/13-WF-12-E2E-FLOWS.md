# WF-12 E2E Flows

## Add size 42
Customer asks to add size 42
→ WF-11 resolves exact variation
→ WF-10 authorizes cart_add
→ WF-12 executes
→ current cart retrieved
→ expected line verified
→ WF-16 renders.

## Remove item
→ WF-10 authorization
→ WF-12 mutation
→ cart verification
→ render.

## Update quantity
→ authorization binds exact target quantity
→ mutation
→ verification.

## Duplicate Messenger event
→ same request/idempotency key
→ previous result/reconciliation returned
→ no duplicate item.

## Human takeover
→ ownership changes to HUMAN
→ WF-12 rejects mutation even if earlier proposal existed.

## Commerce timeout
→ mutation may be unknown
→ reconciliation lookup
→ only verified final cart state is reported.
