# n8n Workflow Blueprint — Node Level

## WF-01 INBOUND-GATE
`Webhook → Normalize → Correlation ID → Idempotency → Rate Limit → Security Precheck → Language → Conversation Load → Identity → Intent`

## WF-02 SECURITY-GATE
`Velocity Check → Loop Check → Size Check → Injection Signal → Risk Classification → Block/Continue`

Injection detection is a signal; never accuse the customer or let the signal itself become a customer-facing claim.

## WF-03 IDENTITY
`Channel Identity → Customer Lookup → Verification State → Sensitive Intent Check → Verification Workflow`

## WF-04 INTENT
`product_discovery | product_question | comparison | pricing | promotion | availability | shipping | payment | order_status | return_exchange | complaint | safety | payment_dispute | checkout | human_request | off_topic | security_suspicion`

## WF-05 RAG
`Normalize Query → Metadata Filter → Vector Search → Optional Rerank → Freshness/Version Filter → Conflict Check → Top-K`

Filters must enforce market, status, language and tenant/store scope.

## WF-06 MAIN-REASONING
Provide bounded conversation state, authorized capabilities, business rules, retrieved KB and verified tool results. Require strict structured output.

## WF-07 ACTION-VALIDATOR
`JSON Schema → Action Allowlist → Parameter Validation → Identity/Permission → Business Rules → Idempotency → Execute → Re-read/Verify`

The LLM never executes an arbitrary tool.

## WF-08 PRODUCT
`Search → Market Filter → Active Filter → Variant Check → Candidate Ranking → Return Facts`

## WF-09 CART
Every mutation: `Validate → Idempotency → Execute → Re-read → Verify → Event`.

## WF-10 CHECKOUT
Only pass through a checkout URL returned by the commerce platform.

## WF-11 ORDER
`Identity Verified? → Order Lookup → Field Minimization → Status Explanation`

## WF-12 ESCALATION
`Trigger → Summary → Handoff Record → Human Queue → Conversation Flag → Customer Message`

## WF-13 OUTBOUND
`Validated Response → Channel Formatter → Public/PII Guard → Send → Record → Event`

## WF-14 ERROR
Handle provider timeout, LLM timeout, invalid JSON, authorization failure, 4xx/5xx, rate limits and vector failures without exposing internal errors.

n8n provides execution history/retry capabilities and a security-audit feature; use them as operational controls in addition to application-level authorization.
