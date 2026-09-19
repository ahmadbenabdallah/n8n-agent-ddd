# n8n Workflow Architecture

## Main workflow

``` text
Webhook
 ↓
Normalize Channel Payload
 ↓
Deduplicate / Idempotency
 ↓
Rate & Abuse Guard
 ↓
Language Detection
 ↓
Identity Resolver
 ↓
Load Conversation State
 ↓
Intent Router
 ↓
Retrieve Business Context
 ↓
Retrieve KB
 ↓
Build Model Context
 ↓
LLM Structured Output
 ↓
JSON Schema Validation
 ↓
Action Authorization
 ↓
Action Execution
 ↓
Post-Action Validation
 ↓
Response Rendering
 ↓
Channel Send
 ↓
State Update
 ↓
Analytics/Audit
```

## Separate sub-workflows

1.  `WF-SECURITY-GATE`
2.  `WF-IDENTITY`
3.  `WF-KB-RETRIEVAL`
4.  `WF-PRODUCT-SEARCH`
5.  `WF-ORDER-LOOKUP`
6.  `WF-CART`
7.  `WF-PROMOTION-VALIDATOR`
8.  `WF-CHECKOUT`
9.  `WF-HUMAN-HANDOFF`
10. `WF-ANALYTICS`
11. `WF-RED-TEAM-EVAL`

## n8n design principles

-   Keep workflows small and composable.
-   Use explicit branches rather than letting an agent decide arbitrary
    workflow paths.
-   Set timeouts and retries.
-   Use idempotency keys for writes.
-   Log tool calls and outcomes.
-   Keep secrets in n8n credentials/environment secrets, never prompts.
-   Use a dead-letter/error workflow for failed executions.

## Retrieval

Use metadata filtering: - market = TN; - status = active; - current
effective date; - product/category/topic; - language.

## Retry policy

Retry transient provider/network failures only.

Do not retry: - authorization failures; - schema failures; - policy
denial; - suspected prompt injection.

## Cost controls

Set: - maximum LLM tokens; - maximum tool calls; - maximum RAG calls; -
maximum retries; - workflow execution timeout; - per-conversation
budget.

## Failure mode

If the LLM fails: - provide a minimal safe response; - do not
fabricate; - retry once if safe; - otherwise escalate or ask the
customer to wait for human support.
