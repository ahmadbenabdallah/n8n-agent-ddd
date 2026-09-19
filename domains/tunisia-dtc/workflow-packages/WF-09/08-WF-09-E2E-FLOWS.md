# WF-09 E2E Flows

## A. Product question
Customer: "chneya garantie mta3 hedha?"
→ WF-11 supplies approved product fact
→ WF-09 drafts answer
→ no mutation
→ WF-16 renders.

## B. Cart add
Customer: "Ok zidhali taille 42 lel panier."
→ WF-03 state/intent = cart action
→ WF-12 supplies product/variant context
→ WF-09 proposes `cart_add`
→ WF-10 validates
→ WF-12 executes
→ result is verified
→ WF-16 renders verified result.

## C. Website-originated order status
Customer asks about order.
→ WF-02/WF-07 establish or request order scope
→ WF-07 obtains fresh status
→ WF-09 drafts status response from verified fact
→ WF-16 renders.

## D. Promotion
Customer provides coupon.
→ WF-13 validates current coupon/eligibility
→ WF-09 proposes explanation based on result
→ WF-10 controls any action
→ no invented discount.

## E. Human request
Customer: "nheb nehki m3a chkoun."
→ WF-08 creates/updates case
→ ownership changes according to WF-08
→ WF-09 only produces permitted acknowledgement
→ no conflicting sales action.

## F. Timeout
LLM call times out.
→ no action execution
→ safe fallback
→ audit event
→ retry only within bounded non-mutating policy.
