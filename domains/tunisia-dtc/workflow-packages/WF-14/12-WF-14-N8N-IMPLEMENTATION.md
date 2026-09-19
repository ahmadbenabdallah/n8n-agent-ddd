# WF-14 n8n Implementation

Recommended flow:

Trigger
→ Validate Checkout Request
→ Validate WF-10 Authorization
→ Load WF-03 State
→ Check WF-08 Ownership
→ Load Cart (WF-12)
→ Validate Identity
→ Validate Checkout Fields
→ Validate Promotion (WF-13)
→ Mandatory Fresh Commerce Preflight
→ Validate Final Total
→ Final Authorization Recheck
→ Execute WF-20 Order Creation
→ Verify Order
→ Persist State
→ Route Transaction State to WF-15
→ Audit WF-17
→ Return verified result to WF-16.

Mutation retries are disabled unless the operation is provably idempotent.
Timeouts enter reconciliation.
