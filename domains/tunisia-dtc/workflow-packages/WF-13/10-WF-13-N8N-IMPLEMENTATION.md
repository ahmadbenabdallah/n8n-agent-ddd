# WF-13 n8n Implementation

Recommended flow:

Trigger
→ Validate Promotion Request
→ Load Canonical State
→ Load Permitted Identity Context
→ Load Cart Context
→ Determine Freshness
→ Execute WF-20 Coupon/Promotion Read
→ Normalize Result
→ Evaluate Explicit Rules
→ Produce Promotion Result
→ Audit
→ Return.

For checkout:
WF-14 must perform a final live promotion/total validation.

Controls:
- bounded coupon length;
- normalized code;
- no arbitrary HTTP;
- no credentials in item data;
- no model-controlled promotion amount;
- timeout handling;
- correlation IDs;
- no mutation retry unless the downstream operation is idempotent.
