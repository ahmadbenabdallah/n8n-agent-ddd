# WF-10 n8n Implementation

Recommended flow:

Trigger
→ Envelope Validation
→ Proposal Schema Validation
→ Action Split
→ Allowlist Lookup
→ Parameter Validation
→ State Load
→ Identity/Scope Load
→ Ownership Load
→ Policy Evaluation
→ Freshness Check
→ Idempotency Check
→ Authorization Decision
→ Authorization Record
→ Target Workflow
→ Post-Execution Verification
→ Audit.

Controls:
- WooCommerce credentials remain isolated in WF-20.
- Never pass credentials through item JSON.
- No generic URL/method/header capability.
- Correlation IDs propagate throughout.
- Use timeouts.
- Do not blindly retry mutations.
- Schema validation is not authorization.
