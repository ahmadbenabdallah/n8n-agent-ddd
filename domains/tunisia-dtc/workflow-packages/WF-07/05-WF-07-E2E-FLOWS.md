# WF-07 E2E Flows

## E2E-1 Returning Messenger customer
1. WF-02 resolves customer.
2. WF-03 loads active scope.
3. WF-10 authorizes requested order read.
4. WF-07 calls WF-20.
5. WooCommerce returns current status.
6. WF-07 normalizes permitted fields.
7. WF-16 renders.

## E2E-2 Website-originated order
1. Customer says they ordered on the website.
2. WF-02 resolves Messenger identity.
3. No active order scope exists.
4. WF-07 asks for minimum approved verification input.
5. WF-20 performs bounded candidate discovery.
6. Application verifies relationship.
7. Scope is persisted.
8. WF-10 authorizes.
9. WF-20 performs fresh read.
10. Renderer responds.

## E2E-3 Multiple orders
1. Discovery returns multiple candidates.
2. WF-07 marks AMBIGUOUS.
3. No candidate details are exposed.
4. Additional configured verification is requested.
5. If unresolved, escalate.

## E2E-4 WooCommerce outage
1. Read authorized.
2. WF-20 unavailable.
3. WF-07 returns COMMERCE_UNAVAILABLE.
4. Renderer does not invent a status.
5. Retry/recovery follows operational policy.
