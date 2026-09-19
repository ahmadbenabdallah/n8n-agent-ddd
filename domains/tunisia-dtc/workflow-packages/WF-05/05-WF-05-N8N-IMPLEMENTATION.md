# WF-05 n8n Implementation Blueprint

## Recommended node sequence

```text
Execute Workflow Trigger
→ Load canonical WF-03 state
→ Validate sales-state envelope
→ Human ownership gate
→ Specific-intent precedence
→ Sales-state transition lookup
→ Required-facts decision
→ Route to downstream workflow / LLM
→ Build sales-plan envelope
→ Persist approved state suggestion through WF-03 contract
→ Emit sales analytics event
→ Return to orchestrator
```

## Node responsibilities

### 1. Execute Workflow Trigger
Accept only the canonical envelope from WF-04/orchestrator.

### 2. Load state
Read canonical state from Supabase/WF-03.

Never use LLM memory as canonical state.

### 3. State validation
Reject:
- unknown sales stage
- malformed identity state
- stale state version
- missing conversation ID

Use optimistic concurrency where state is updated.

### 4. Human ownership gate

Pseudo-logic:

```text
if owner == HUMAN and automation_mode == PAUSED:
    route to human case
if owner == HUMAN and automation_mode == SAFE_ONLY:
    permit only safe/non-conflicting handling
else:
    continue normal sales logic
```

This is not a replacement for WF-10 authorization.

### 5. Specific-intent precedence

Map exact routed intents before generic sales handling.

Never let:
`product_question`
override:
`cart_add`, `cart_update`, `checkout_confirm`, etc.

### 6. State transition lookup

Use an allowlist table rather than arbitrary expressions from the LLM.

Example:

```text
PRODUCT_INTEREST + customer_selects_product
→ PRODUCT_SELECTED

PRODUCT_SELECTED + cart_add
→ CART_BUILDING

CART_BUILDING + checkout_start
→ CHECKOUT_READY
```

### 7. Required-facts decision

Examples:

```text
product_question → WF-11 product facts
pricing → WF-11 current price
availability → WF-11 live availability
promotion → WF-13 validation
cart_add → WF-12
checkout_start → WF-14 fresh preflight
order_status → WF-07
```

### 8. LLM handoff

Only send the minimum trusted context.

The LLM returns a strict structured proposal.
Do not let raw LLM output directly mutate state.

### 9. Return envelope

Example:

```json
{
  "workflow": "WF-05",
  "workflow_version": "v4",
  "sales_stage_before": "PRODUCT_SELECTED",
  "sales_stage_candidate": "CART_BUILDING",
  "intent": "cart_add",
  "next_workflow": "WF-12",
  "action_required": true,
  "action_proposal": {},
  "authorization_required": true
}
```

## Error codes

```text
WF05_INVALID_STATE
WF05_STALE_STATE
WF05_HUMAN_OWNED
WF05_UNSUPPORTED_TRANSITION
WF05_MISSING_FACTS
WF05_REPETITION_LIMIT
WF05_COMMERCE_DEPENDENCY_UNAVAILABLE
WF05_INVALID_LLM_PROPOSAL
WF05_SALES_POLICY_BLOCK
```

## Retry

WF-05 itself should be mostly deterministic and low-retry.

Do not retry downstream writes blindly.
Write retries require idempotency and downstream workflow ownership.

## Secrets

No WooCommerce credentials, API keys, access tokens, Cart-Tokens, nonce tokens or other secrets belong in WF-05 prompts, logs, or LLM context.
