# Tunisia DTC AI Agent — MASTER IMPLEMENTATION FILE
## Production Implementation Blueprint — WF-00 → WF-20

**Version:** 1.0  
**Date:** 2026-09-17  
**Status:** Master implementation specification  
**Commerce:** WooCommerce  
**Payment:** Cash on Delivery (COD)  
**Shipping:** Manual initially  
**Orchestration:** Self-hosted n8n  
**AI:** OpenAI  
**RAG:** Supabase + pgvector  
**Initial channel:** Meta Messenger

---

# 1. Executive Architecture

The production runtime is based on one non-negotiable control pattern:

> **LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer replies.**

The LLM is a reasoning component, not an execution authority.

### Hard boundaries

| Boundary | Owner | Rule |
|---|---|---|
| Inbound | WF-00 | Normalize and deduplicate |
| Security | WF-01 | Detect threats and enforce limits |
| Identity | WF-02 | Determine verified identity/scope |
| State | WF-03 | Persist canonical conversation state |
| Intent | WF-04 | Route request |
| Business logic | WF-05–08 | Decide workflow path |
| Reasoning | WF-09 | Generate structured proposal |
| Authorization | **WF-10** | **Only place allowed to authorize consequential actions** |
| Commerce services | WF-11–15 | Execute bounded business operations |
| WooCommerce | **WF-20** | **Only privileged WooCommerce boundary** |
| Renderer | WF-16 | Customer-visible output only |
| Audit | WF-17 | Observability/audit; never authorization |
| KB | WF-18 | Approved knowledge ingestion |
| Operations | WF-19 | Monitoring, reconciliation, maintenance |

---

# 2. Production Components

## 2.1 n8n

Self-hosted n8n is the orchestration/control plane.

Responsibilities:
- webhook handling
- workflow routing
- validation
- authorization
- retries
- idempotency
- service orchestration
- WooCommerce integration
- OpenAI invocation
- Supabase persistence
- audit/event emission
- escalation
- operational monitoring

n8n credentials/secrets must contain provider credentials. Secrets must never be embedded in prompts, KB documents, customer messages or ordinary execution logs.

## 2.2 OpenAI

OpenAI is used for bounded reasoning.

The model receives:
- normalized customer message
- bounded conversation history
- verified state
- authorized capabilities
- approved KB facts
- verified commerce facts
- language/script context
- escalation status
- relevant business rules

The model does NOT receive:
- secrets
- WooCommerce credentials
- payment credentials
- raw private data not required for the task
- unrestricted API capability
- arbitrary endpoint information

## 2.3 Supabase

Supabase is the source of truth for:
- conversation state
- identity/context state
- action records
- idempotency records
- audit/event records
- KB metadata
- pgvector embeddings
- reconciliation state

WooCommerce remains authoritative for live commerce state.

## 2.4 WooCommerce

WooCommerce is authoritative for:
- current product price
- current stock
- cart state where applicable
- coupon/promotion validity
- checkout total
- order status
- payment status

---

# 3. Environment Configuration

Create separate environments:

- development
- staging
- production

Minimum environment variables:

```text
N8N_ENCRYPTION_KEY
N8N_HOST
N8N_PROTOCOL
N8N_PORT

SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY
SUPABASE_ANON_KEY

OPENAI_API_KEY

WOOCOMMERCE_BASE_URL
WOOCOMMERCE_CONSUMER_KEY
WOOCOMMERCE_CONSUMER_SECRET

META_VERIFY_TOKEN
META_APP_SECRET
META_PAGE_ACCESS_TOKEN

LOG_LEVEL
ENVIRONMENT
```

Secrets belong in n8n credentials or secure environment configuration.

Never put credentials into:
- prompts
- Git
- KB
- customer-visible text
- audit payloads
- LLM context.

---

# 4. Canonical Request Envelope

Every inbound event must be normalized into one internal envelope.

```json
{
  "event_id": "evt_...",
  "conversation_id": "conv_...",
  "channel": "facebook",
  "received_at": "ISO-8601",
  "customer": {
    "customer_id": null,
    "identity_level": 0
  },
  "message": {
    "message_id": "msg_...",
    "text": "...",
    "language": "tn",
    "script": "latin"
  },
  "context": {
    "page_id": "...",
    "thread_id": "...",
    "source": "messenger"
  }
}
```

`event_id` must be stable enough for duplicate-event detection.

---

# 5. End-to-End Runtime

## Step 1 — Receive

Meta Messenger sends event to WF-00.

## Step 2 — Normalize

WF-00 converts provider payload to canonical schema.

## Step 3 — Idempotency

Check whether `event_id` has already been processed.

If yes:
- do not repeat consequential processing;
- return/reuse the previous safe outcome where applicable.

## Step 4 — Security

WF-01 checks:
- malformed input
- oversized input
- suspicious patterns
- prompt injection indicators
- excessive requests
- security flags
- abuse/velocity
- public-channel privacy constraints

## Step 5 — Identity

WF-02 determines identity level and order scope.

## Step 6 — State

WF-03 loads/persists canonical state.

## Step 7 — Intent

WF-04 routes to the correct intent.

## Step 8 — Business Logic

Route to:
- WF-05 Sales
- WF-06 Support
- WF-07 Order
- WF-08 Escalation

## Step 9 — Reasoning

WF-09 asks the LLM for a structured proposal.

## Step 10 — Authorization

WF-10 validates:
- schema
- action allowlist
- required parameters
- identity
- order scope
- state
- business rules
- security flags
- escalation ownership
- idempotency

Only WF-10 may produce:

```json
{
  "execution_allowed": true
}
```

## Step 11 — Service Execution

Authorized actions route through WF-11–WF-15.

## Step 12 — WooCommerce

WF-20 performs privileged WooCommerce calls.

## Step 13 — Verification

Read authoritative state after consequential writes.

## Step 14 — Rendering

WF-16 creates customer-facing text from verified facts.

## Step 15 — Audit

WF-17 emits safe event records.

---

# 6. Workflow Implementation Specifications

# WF-00 — Inbound Gateway

### Purpose
Provider-neutral inbound gateway.

### Input
Meta Messenger webhook.

### Nodes
1. Webhook
2. Signature/verification check
3. Normalize
4. Set canonical fields
5. Generate/resolve event ID
6. Idempotency lookup
7. IF duplicate
8. Execute Workflow → WF-01

### Rules
- Reject malformed payloads.
- Bound message size.
- Normalize Unicode safely.
- Preserve original message only where policy permits.
- Never send raw provider payload into the LLM.

### Output

```json
{
  "event_id": "...",
  "conversation_id": "...",
  "channel": "facebook",
  "message": {},
  "security": {}
}
```

---

# WF-01 — Security Gate

### Purpose
Security controls before identity/reasoning.

### Checks
- input size
- rate/velocity
- prompt injection indicators
- malicious content
- suspicious URLs
- repeated abuse
- public-channel privacy
- security incident indicators

### Decision

```text
ALLOW
LIMIT
ESCALATE
BLOCK
```

Consequential operations fail closed if security state is unavailable.

---

# WF-02 — Identity

### Levels

```text
0 Anonymous
1 Channel-linked
2 Order-verified
3 High-assurance
```

### Rules
The LLM cannot promote identity.

Order number/name/phone/customer claim/history alone is insufficient proof for protected operations.

### Output

```json
{
  "identity_level": 1,
  "customer_id": "...",
  "order_scope": []
}
```

---

# WF-03 — Conversation State

### Canonical fields

```text
conversation_id
channel
language
script
intent
sub_intent
sales_stage
identity_level
selected_products
cart_id
order_scope
last_action_id
last_idempotency_key
last_authorization_result
last_execution_result
last_verified_commerce_at
turn_count
escalation_status
human_owner
risk_flags
recovery_status
last_updated
```

### Rule

State is application-owned and deterministic.

LLM suggestions are advisory only.

---

# WF-04 — Intent Router

### Supported intents

```text
product_discovery
product_question
comparison
pricing
promotion
availability
shipping
payment
cart_view
cart_add
cart_remove
cart_update
cart_clear
checkout_start
checkout_confirm
order_status
return_exchange
complaint
payment_dispute
human_request
safety
security_suspicion
off_topic
```

### Routing examples

`"show me black shoes"` → `product_discovery`

`"how much is size 42?"` → `pricing` / `product_question`

`"zidhali taille 42 lel panier"` → `cart_add` or `cart_update`

`"win waslet commande?"` → `order_status`

`"nheb nraja3 l'article"` → `return_exchange`

---

# WF-05 — Sales Engine

### Sales state machine

```text
NEW
↓
BROWSING
↓
DISCOVERY
↓
PRODUCT_INTEREST
↓
CONSIDERING
↓
PRODUCT_SELECTED
↓
CART_BUILDING
↓
CHECKOUT_READY
↓
PURCHASED
↓
POST_PURCHASE
```

Supporting states:

```text
OBJECTION_HANDLING
WAITING_FOR_CUSTOMER
HUMAN_ESCALATION
CLOSED
```

### Responsibilities

- understand need
- recommend products
- answer product questions
- handle objections
- manage commercial conversation
- initiate cart actions
- initiate checkout when appropriate

Never fabricate urgency, scarcity, discount or product claims.

---

# WF-06 — Support Engine

### Responsibilities

- shipping policy
- payment policy
- returns/exchanges
- complaints
- FAQs
- support troubleshooting

Static policy facts come from approved KB.

Dynamic order facts come from WooCommerce.

Payment disputes escalate.

---

# WF-07 — Order Service

### Supported operations

```text
order.get
order.create
order.update
order.cancel
```

### Requirements

Order operations require:
- correct identity
- order scope
- WF-10 authorization
- idempotency
- WF-20 execution
- post-verification

Never expose internal order notes, fraud data, supplier information or unrelated customer information.

---

# WF-08 — Escalation Engine

### Mandatory escalation

- safety
- payment disputes
- chargebacks
- legal threats
- serious complaints
- damaged/defective cases requiring review
- identity uncertainty
- unauthorized activity
- security incidents
- repeated unresolved failures
- mandatory human requests

### States

```text
ACTIVE
→ HUMAN_REQUESTED
→ HUMAN_ASSIGNED
→ HUMAN_IN_PROGRESS
→ RESOLVED
→ CLOSED
```

Once human ownership is active, conflicting automation stops.

---

# WF-09 — LLM Reasoning

### Model role

The LLM performs:
- intent interpretation
- product reasoning
- conversational response planning
- action proposal
- state suggestion

The LLM does NOT:
- authorize
- execute
- set final price
- set stock
- confirm payment
- create arbitrary URLs
- bypass identity
- bypass escalation
- access secrets

### Context construction

Only inject:
- verified state
- bounded history
- approved KB snippets
- live commerce facts
- allowed capabilities
- business rules
- language/script requirements

---

# WF-10 — Action Validator

## THE HARD AUTHORIZATION BOUNDARY

No consequential action bypasses WF-10.

### Validation sequence

```text
Parse schema
↓
Action allowlist
↓
Parameter validation
↓
Identity validation
↓
Order scope validation
↓
State validation
↓
Business-rule validation
↓
Security/risk validation
↓
Escalation ownership check
↓
Idempotency validation
↓
Authorization decision
```

### Authorization output

```json
{
  "execution_allowed": true,
  "authorization_id": "auth_...",
  "action_id": "act_...",
  "idempotency_key": "idem_...",
  "reason_code": "AUTHORIZED"
}
```

### Denial examples

```text
IDENTITY_REQUIRED
ORDER_SCOPE_REQUIRED
ACTION_NOT_ALLOWED
MISSING_PARAMETER
INVALID_PARAMETER
STALE_STATE
HUMAN_OWNERSHIP_ACTIVE
SECURITY_BLOCK
DUPLICATE_ACTION
BUSINESS_RULE_DENIED
```

---

# WF-11 — Product Service

### Responsibilities

- product search
- product retrieval
- variant retrieval
- current price
- current stock

### WooCommerce

All live product data is retrieved through WF-20.

### Important

KB may describe stable product attributes but must not override current WooCommerce price/stock.

---

# WF-12 — Cart Service

### Operations

```text
cart.view
cart.add
cart.update
cart.remove
cart.clear
```

### Mutation requirements

- verified session/customer context
- SKU
- variant
- quantity
- authorization
- idempotency
- current availability
- authoritative result

### Success

Only report cart mutation success after WooCommerce confirms it.

---

# WF-13 — Promotion Service

### Operation

```text
promotion.validate
```

### Validate

- code
- existence
- active period
- market
- SKU restrictions
- category restrictions
- minimum subtotal
- customer eligibility
- usage limits
- stacking rules
- expiry

### Authority

Live WooCommerce promotion state.

Do not infer promotions from:
- old campaigns
- conversation history
- cached KB
- another customer's promotion
- model assumptions

---

# WF-14 — Checkout Service

## Fresh preflight is mandatory

Immediately before checkout/order mutation:

```text
Read cart
↓
Read current product/variant state
↓
Validate current price
↓
Validate inventory
↓
Validate promotion
↓
Validate expected total
↓
Authorize
↓
Create backend checkout/order operation
```

### Checkout URL

Backend-generated only.

The LLM must never construct a checkout URL.

---

# WF-15 — Transaction Service

### Purpose

Transaction/order orchestration and recovery.

### COD semantics

For Cash on Delivery:

```text
order_created = true
payment_status = not_paid
```

Creating an order is NOT payment confirmation.

### Ambiguous write recovery

If WooCommerce times out after a write:

1. Do not blindly retry.
2. Preserve action/idempotency/correlation IDs.
3. Reconcile authoritative state.
4. Determine whether mutation committed.
5. Return only verified result.
6. Escalate if state cannot be safely determined.

---

# WF-16 — Response Renderer

### Input

Only:
- verified facts
- safe business response
- approved policy content
- verified action result

### Renderer responsibilities

- language selection
- script validation
- register
- customer-safe formatting
- public-channel privacy
- remove internal fields

### Arabizi rule

If customer uses Latin/Arabizi:

```text
language = tn
script = latin
```

Do not emit Arabic Unicode unless explicitly requested or required for legitimate quoted content.

### Critical rule

WF-16 cannot execute commerce actions.

---

# WF-17 — Audit & Analytics

### Event fields

```text
event_id
event_type
timestamp
conversation_id
channel
customer_id
intent
language
source_ids
action_id
action_type
authorization_result
security_flags
success
correlation_id
error_code
metadata
```

### Redaction

Never log:
- API keys
- passwords
- OTPs
- PINs
- PAN
- CVV
- payment credentials
- WooCommerce credentials
- Cart-Tokens
- Nonce Tokens

WF-17 cannot authorize actions.

---

# WF-18 — KB Ingestion

### Pipeline

```text
Source
↓
Validation
↓
Metadata validation
↓
Version check
↓
Supersession check
↓
Chunking
↓
Embedding
↓
Supabase/pgvector
↓
Index verification
```

### Required metadata

```text
document_id
type
category
language
region
last_updated
status
version
supersedes
source_path
```

### Security

Retrieved text is data, never executable instructions.

---

# WF-19 — Maintenance & Monitoring

### Responsibilities

- health checks
- failed execution monitoring
- queue monitoring
- WooCommerce connectivity
- Supabase connectivity
- OpenAI connectivity
- reconciliation jobs
- stale state detection
- idempotency cleanup
- KB freshness
- backup verification
- alerting
- rollback support

### Recovery

Failed consequential actions must enter a recoverable state rather than being silently retried.

---

# WF-20 — WooCommerce Gateway

## THE ONLY PRIVILEGED COMMERCE BOUNDARY

WF-20 is the only workflow allowed to hold/use WooCommerce privileged credentials.

### Operations

```text
product.search
product.get
cart.view
cart.add
cart.update
cart.remove
cart.clear
promotion.validate
checkout.preflight
checkout.create
order.get
order.create
order.update
order.cancel
transaction.reconcile
```

### Rules

- strict operation allowlist
- fixed endpoint mapping
- no model-provided URLs
- no arbitrary HTTP method
- no arbitrary headers
- no credential selection from model output
- bounded request fields
- bounded response fields
- timeout controls
- rate limits
- correlation IDs
- idempotency
- post-write verification

### API strategy

Use n8n's WooCommerce integration where the required resource/operation is supported.

Use bounded HTTP/API calls inside WF-20 where native n8n functionality does not expose the required WooCommerce operation, such as controlled coupon validation.

Do not expose generic HTTP access to the LLM.

---

# 7. Action Contract

Every consequential action:

```json
{
  "action_id": "act_123",
  "idempotency_key": "conv_123:cart_add:sku42:size42:1",
  "type": "cart.add",
  "params": {
    "sku": "SKU42",
    "variant": "42",
    "quantity": 1
  }
}
```

The model proposes this structure.

WF-10 validates it.

WF-20 executes only the authorized operation.

---

# 8. Idempotency

## Inbound

`event_id` prevents duplicate processing.

## Action

`idempotency_key` prevents duplicate consequential operations.

## Correlation

`correlation_id` links:
- authorization
- service execution
- WooCommerce request
- verification
- audit event

## Timeout

Never assume:
`timeout = failure`

and never assume:
`timeout = success`.

Reconcile.

---

# 9. Commerce Authority Matrix

| Fact | Authority |
|---|---|
| Stable product description | KB |
| Current price | WooCommerce |
| Current stock | WooCommerce |
| Promotion validity | WooCommerce |
| Cart state | WooCommerce |
| Checkout total | WooCommerce |
| Order status | WooCommerce |
| Payment status | WooCommerce |
| Conversation state | Supabase |
| Identity level | Supabase/application |
| Human ownership | Supabase/application |

---

# 10. Supabase Data Model

Recommended core tables:

## conversations

```text
id
conversation_id
channel
language
script
sales_stage
identity_level
escalation_status
human_owner
turn_count
created_at
updated_at
```

## conversation_state

```text
conversation_id
intent
sub_intent
selected_products
cart_id
order_scope
last_action_id
last_idempotency_key
last_authorization_result
last_execution_result
last_verified_commerce_at
risk_flags
recovery_status
updated_at
```

## actions

```text
action_id
conversation_id
type
idempotency_key
authorization_status
execution_status
correlation_id
request_hash
result_hash
created_at
updated_at
```

## idempotency_keys

```text
idempotency_key
conversation_id
action_id
status
result_reference
created_at
expires_at
```

## events

```text
event_id
event_type
conversation_id
channel
action_id
authorization_result
success
error_code
correlation_id
metadata
created_at
```

## kb_documents

```text
document_id
type
category
language
region
status
version
supersedes
last_updated
source_path
```

## kb_chunks

```text
chunk_id
document_id
content
embedding
metadata
created_at
```

## reconciliations

```text
reconciliation_id
action_id
correlation_id
commerce_object_type
commerce_object_id
status
last_checked_at
resolution
```

---

# 11. Security Threat Model

## Prompt injection

Control:
- untrusted content isolation
- no privilege escalation
- structured output
- WF-10 authorization

## Sensitive information disclosure

Control:
- minimum context
- field filtering
- renderer redaction
- public-channel restrictions

## Excessive agency

Control:
- action allowlist
- WF-10
- WF-20
- identity/scope

## Tool misuse

Control:
- fixed operation mapping
- no arbitrary endpoints
- no model-controlled credentials

## KB poisoning

Control:
- approved sources
- metadata
- versioning
- status
- supersession
- ingestion validation

## Vector weaknesses

Control:
- metadata filtering
- region/status filters
- approved corpus
- source attribution

## Unbounded consumption

Control:
- token limits
- bounded history
- bounded retrieval
- max tool calls
- rate limiting
- turn limits

---

# 12. Language and Script

Canonical representation:

```json
{
  "language": "tn",
  "script": "latin",
  "register": "casual",
  "mixed_languages": ["tn", "fr"]
}
```

Language and script are separate.

Examples:

```text
"chneya prix mta3ou?"
language=tn
script=latin
```

```text
"بقداش هذا؟"
language=tn/ar-context
script=arabic
```

```text
"c'est dispo taille 42?"
language=mixed
script=latin
```

The renderer performs final validation.

---

# 13. Escalation Data Contract

```json
{
  "conversation_id": "...",
  "channel": "facebook",
  "language": "tn",
  "intent": "payment_dispute",
  "summary": "...",
  "verified_facts": [],
  "authorized_order_context": {},
  "actions_attempted": [],
  "error_codes": [],
  "risk_flags": [],
  "recommended_human_next_step": "..."
}
```

Never include secrets or unnecessary PII.

---

# 14. Error Contract

Every service returns:

```json
{
  "success": false,
  "code": "OUT_OF_STOCK",
  "safe_message": "The requested variant is currently unavailable.",
  "action_id": "act_...",
  "correlation_id": "corr_..."
}
```

Internal diagnostic details remain outside customer-facing output.

---

# 15. Retry Policy

## Safe to retry

Usually:
- read operations
- idempotent lookups
- KB retrieval

## Do not blindly retry

- order creation
- cart mutation
- cancellation
- checkout mutation
- other consequential writes

Use idempotency + reconciliation.

---

# 16. Production Deployment

## Phase 1

Development:
- unit tests
- schema tests
- prompt tests
- workflow tests

## Phase 2

Staging:
- real WooCommerce staging/test environment
- Meta test page/account
- realistic product/catalog fixtures

## Phase 3

Shadow mode:
- reason and route
- do not execute consequential writes
- compare expected outcomes

## Phase 4

Canary:
- limited traffic
- strict monitoring
- rapid rollback

## Phase 5

Production:
- progressive traffic
- continuous monitoring
- human escalation available

---

# 17. Rollback

Rollback triggers include:

- unauthorized commerce action
- duplicate order creation
- payment-state corruption
- protected-data disclosure
- security incident
- widespread workflow failure
- WooCommerce integration instability

Emergency mode:

```text
Disable consequential automation
↓
Keep informational support if safe
↓
Route sensitive requests to humans
↓
Reconcile outstanding actions
↓
Investigate
↓
Deploy fix
↓
Run regression suite
↓
Resume canary
```

---

# 18. Observability

Track:

### Reliability
- webhook failures
- workflow failures
- latency
- timeout rate
- WooCommerce errors
- Supabase errors
- OpenAI errors

### Agent quality
- intent accuracy
- escalation rate
- action denial rate
- hallucination/regression tests
- response language/script violations

### Commerce
- cart additions
- checkout starts
- orders created
- duplicate prevention
- reconciliation count
- promotion validation failures

### Security
- prompt injection detections
- blocked actions
- identity failures
- suspicious activity
- sensitive-data violations

---

# 19. Red-Team Acceptance Tests

Minimum categories:

1. Prompt injection
2. KB poisoning
3. Identity bypass
4. Unauthorized order access
5. Unauthorized cancellation
6. Arbitrary endpoint request
7. Missing idempotency
8. Duplicate webhook
9. Duplicate cart mutation
10. Duplicate order attempt
11. WooCommerce timeout
12. Stale price
13. Stock race
14. Expired coupon
15. Invalid coupon
16. COD payment hallucination
17. Public PII disclosure
18. Prompt leakage
19. Secret leakage
20. Language/script regression
21. Human-handoff bypass
22. Unbounded tool loop
23. Excessive retrieval
24. Malicious KB instruction
25. Unsupported action type

Production acceptance fails if any test demonstrates:
- unauthorized execution
- sensitive leakage
- invented commerce facts
- unverified success
- duplicate consequential mutation
- escalation bypass
- secret exposure.

---

# 20. Example End-to-End: Cart Add

Customer:

> "Ok zidhali taille 42 lel panier."

### WF-00
Normalize.

### WF-01
No security block.

### WF-02
Identity/session context resolved.

### WF-03
Load state.

### WF-04
Intent:

```text
cart_add
```

### WF-05
Determine selected product and requested variant.

### WF-09
LLM proposes:

```json
{
  "action_id": "act_001",
  "idempotency_key": "conv_001:cart_add:SKU123:42:1",
  "type": "cart.add",
  "params": {
    "sku": "SKU123",
    "variant": "42",
    "quantity": 1
  }
}
```

### WF-10
Checks identity, state, SKU, variant, quantity, authorization and idempotency.

### WF-12
Cart service requests live validation.

### WF-20
WooCommerce confirms current stock and performs cart mutation.

### WF-12
Receives authoritative cart state.

### WF-16
Generates Tounsi Latin response.

### WF-17
Records safe event.

Only now may the system say the item was added.

---

# 21. Example End-to-End: COD Order

### Customer confirms checkout.

WF-14 performs fresh preflight.

WF-10 authorizes.

WF-15 creates order through WF-20.

WooCommerce returns order.

WF-15 verifies:

```text
order_status = processing/pending/etc. according to actual WooCommerce result
payment_status = not_paid
payment_method = COD
```

The system must not tell the customer:

> "Payment received."

It may say that the COD order was created if and only if creation and verification succeeded.

---

# 22. Example: WooCommerce Timeout

Order creation request is sent.

WooCommerce times out.

### Incorrect behavior

Retry order creation immediately.

### Correct behavior

```text
Mark execution = AMBIGUOUS
↓
Query/reconcile authoritative WooCommerce state
↓
Match correlation/idempotency/order identifiers where possible
↓
If order exists → verified success
↓
If order does not exist and safe retry is permitted → controlled retry
↓
Otherwise escalate
```

No customer-facing success claim before verification.

---

# 23. Production Invariants

These must remain true after every future modification:

1. LLM never directly executes commerce.
2. WF-10 is the sole authorization boundary.
3. WF-20 is the sole privileged WooCommerce boundary.
4. WF-16 only renders verified facts.
5. WF-17 never authorizes.
6. Dynamic commerce facts come from live commerce.
7. Consequential writes require authorization and idempotency.
8. Sensitive operations require appropriate identity/scope.
9. Checkout/order mutations use fresh state.
10. Ambiguous writes use reconciliation.
11. COD order creation does not equal payment.
12. Secrets never enter LLM/customer/log contexts.
13. Human ownership blocks conflicting automation.
14. Public channels do not expose private data.
15. Language/script is validated before sending.
16. Security/authorization/verification failure is fail-closed for consequential actions.

---

# 24. Implementation Order

Build in this order:

```text
1. Infrastructure
2. Supabase schema
3. n8n credentials
4. WF-00
5. WF-01
6. WF-02
7. WF-03
8. WF-04
9. WF-20
10. WF-11
11. WF-12
12. WF-13
13. WF-14
14. WF-15
15. WF-10
16. WF-05
17. WF-06
18. WF-07
19. WF-08
20. WF-09
21. WF-16
22. WF-17
23. WF-18
24. WF-19
25. E2E testing
26. Red-team
27. Shadow mode
28. Canary
29. Production
```

The sequence deliberately establishes security, identity, state and commerce boundaries before enabling autonomous reasoning and consequential actions.

---

# 25. Final Definition of Done

The implementation is production-ready only when:

- all WF-00–WF-20 contracts are implemented;
- WF-10 is enforced as the hard authorization boundary;
- WF-20 is the only privileged WooCommerce path;
- all consequential writes have idempotency;
- ambiguous writes reconcile;
- checkout performs fresh preflight;
- COD payment semantics are correct;
- identity/order scope is enforced;
- public-channel privacy is enforced;
- secrets are isolated;
- RAG content is versioned and approved;
- language/script validation works;
- human escalation works;
- audit events are safe and useful;
- red-team suite passes;
- E2E suite passes;
- staging is validated;
- shadow/canary phases complete;
- rollback is tested;
- monitoring and alerting are active.

**This document is the master implementation contract. Any workflow, prompt, schema or integration change should be checked against it before release.**
