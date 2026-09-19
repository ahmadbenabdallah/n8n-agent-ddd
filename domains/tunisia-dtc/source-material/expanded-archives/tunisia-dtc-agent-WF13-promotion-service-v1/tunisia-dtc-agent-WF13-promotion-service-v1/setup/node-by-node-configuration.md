# Node-by-node configuration

1. **Execute Workflow Trigger** — internal sub-workflow only.
2. **Validate Promotion Input** — checks contract and supported operations.
3. **Promotion Input Valid?** — fail closed.
4. **Reject Invalid Input** — safe rejection.
5. **Check Promotion Authorization** — read-only promotion/pricing can be evaluated; transactional use must carry an authorized action.
6. **Authorization Valid?** — fail closed.
7. **Reject Unauthorized Promotion Operation** — no evaluation/execution.
8. **Prepare Promotion Evaluation** — normalizes promotion codes, cart, customer and candidate promotions.
9. **Evaluate Eligibility** — deterministic checks for active window, minimum order, customer allowlist and usage limits.
10. **Apply Stacking and Exclusivity** — exclusive promotions override stackable candidates; priority determines deterministic ordering.
11. **Build Promotion Quote** — computes a bounded preliminary discount.
12. **Require Live Validation for Transactional Use** — transactional paths require a verified live source.
13. **Build Promotion Service Contract** — sanitized output; `execution_allowed` remains false.

## Production adapter

Before checkout, connect a live promotion API/database and place its verified result in:
`promotion_context.live_source_result`

Expected:
`{ verified:true, promotion_ids:[], discount:number, currency:"TND", rules_version:"..." }`

A missing or unverified live result must not be treated as valid for transactional use.
