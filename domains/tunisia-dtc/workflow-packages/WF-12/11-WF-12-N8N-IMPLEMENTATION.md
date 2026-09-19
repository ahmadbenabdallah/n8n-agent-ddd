# WF-12 n8n Implementation

Recommended flow:

Trigger
→ Validate Cart Request
→ Validate WF-10 Authorization
→ Load Canonical State
→ Load Ownership
→ Resolve Product/Variation via WF-11
→ Fresh Commerce Precondition
→ Idempotency Check
→ Execute WF-20 Cart Mutation
→ Retrieve Current Cart
→ Verify Expected Result
→ Persist Cart/State
→ Audit
→ Return Result.

Controls:
- no model-controlled HTTP nodes;
- no credentials in JSON;
- bounded quantities;
- bounded cart lines/response size;
- deterministic normalization;
- no blind mutation retries;
- correlation IDs propagated.
