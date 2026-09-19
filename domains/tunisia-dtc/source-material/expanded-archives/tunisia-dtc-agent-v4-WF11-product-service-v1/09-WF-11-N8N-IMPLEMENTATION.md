# WF-11 n8n Implementation

Recommended flow:

Trigger
→ Validate Request Contract
→ Normalize Search/Product/Variation Input
→ Determine Fact Freshness
→ Cache Read for non-consequential browsing
→ IF Freshness Required
→ Execute WF-20 Product Operation
→ Normalize WooCommerce Response
→ Validate Required Fields
→ Apply Output Field Allowlist
→ Return Product Contract
→ Audit

## Controls
- No arbitrary HTTP nodes controlled by model output.
- WF-20 credentials remain isolated.
- Bound search terms, result count and response size.
- Cache only where the freshness policy allows.
- Record correlation IDs.
- Treat WooCommerce failures as structured errors.
- Never manufacture fallback product facts.
