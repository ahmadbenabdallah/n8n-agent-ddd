# WF-00 → WF-20 Implementation Catalog

## WF-00 Inbound Gateway
Input: Meta Messenger webhook.
Responsibilities:
- verify webhook authenticity;
- normalize payload;
- create request/message identifiers;
- reject malformed payloads;
- establish channel context.

Must not:
- call commerce mutation;
- trust customer text as system instructions.

## WF-01 Security Gate
Responsibilities:
- input size/rate controls;
- malicious/injection indicators;
- sensitive-data detection;
- security risk classification;
- reject or quarantine unsafe requests.

Output includes security decision.

## WF-02 Customer Identity
Identity ladder:
`ANONYMOUS → CHANNEL-LINKED → COMMERCE-MATCHED → ORDER-VERIFIED → HIGH-ASSURANCE`

Messenger identity maps to internal customer_id and, where available, WooCommerce customer_id.

Rules:
- LLM cannot promote identity.
- Name, phone, order number, or history alone do not automatically prove identity.
- Order scope must be explicitly established.
- Never request passwords, OTPs, card data, CVV, API keys, or authentication secrets.

## WF-03 Conversation State
Canonical state lives outside the LLM.

Minimum fields:
- conversation_id
- channel
- language
- script
- intent
- sub_intent
- sales_stage
- identity_level
- selected_products
- cart_id
- order_scope
- last_action_id
- turn_count
- escalation_status
- risk_flags
- last_updated

LLM state suggestions are advisory only.

## WF-04 Intent Router
Use the canonical taxonomy:
product_discovery, product_question, comparison, pricing, promotion, availability, shipping, payment, cart_view, cart_add, cart_remove, cart_update, cart_clear, checkout_start, checkout_confirm, order_status, return_exchange, complaint, payment_dispute, human_request, safety, security_suspicion, off_topic.

## WF-05 Sales Engine
Implements sales state:
NEW → BROWSING → DISCOVERY → PRODUCT_INTEREST → CONSIDERING → PRODUCT_SELECTED → CART_BUILDING → CHECKOUT_READY → PURCHASED → POST_PURCHASE

No deceptive selling.

## WF-06 Support Engine
Handles factual support and issue triage.
Mandatory escalation for:
- payment disputes;
- chargebacks;
- legal threats;
- serious complaints;
- damaged/defective review cases;
- identity uncertainty;
- unauthorized activity;
- repeated failures;
- security incidents;
- explicit human request.

## WF-07 Order Service
Responsibilities:
- order lookup;
- order-scope enforcement;
- order creation coordination;
- status retrieval;
- website-originated order linking after verification.

Order creation is not payment.

## WF-08 Escalation Engine
Human ownership states:
`ACTIVE → HUMAN_REQUESTED → HUMAN_ASSIGNED → HUMAN_IN_PROGRESS → RESOLVED → CLOSED`

When human owns the case, automation must not issue conflicting actions.

## WF-09 LLM Reasoning
Produces structured proposals only:
- intent;
- response proposal;
- action proposals;
- citations/source IDs;
- state suggestion.

No direct tool execution.

## WF-10 Action Authorization
Hard security boundary.

Only this workflow can set:
`execution_allowed = true`

Checks:
- allowed action;
- identity;
- order scope;
- parameter schema;
- business rules;
- promotion rules;
- current state;
- idempotency;
- security state;
- escalation ownership.

## WF-11 Product Service
Read-only product/catalog service.
Dynamic facts such as price/stock must come from live commerce.

## WF-12 Cart Service
Handles:
- view;
- add;
- remove;
- update;
- clear.

Cart mutation must be idempotent and verified.

## WF-13 Promotion Service
Validates promotions against current commerce state.
LLM cannot invent discounts or final prices.

## WF-14 Checkout Service
Revalidates:
- product;
- quantity;
- price;
- stock;
- promotion;
- totals;
- customer/checkout data.

Never trust stale LLM or KB totals.

## WF-15 Transaction Service
For COD:
- order creation may succeed;
- payment status remains `not_paid`.

Transaction records must be idempotent.

## WF-16 Response Renderer
Customer-facing boundary.
Renders verified facts only.
Enforces language/script/register.
For Latin/Arabizi input, no Arabic Unicode in output unless explicitly requested or legitimately quoting.

## WF-17 Audit & Analytics
Append-only event stream.
Tracks:
- request lifecycle;
- authorization;
- execution;
- verification;
- escalation;
- LLM telemetry;
- security events;
- operational metrics.

Audit does not authorize.

## WF-18 Knowledge Base Ingestion
Pipeline:
source registration → normalization → chunking → embedding → indexing → quality gate → publication.

Static KB and dynamic commerce facts remain separate.

## WF-19 Maintenance & Monitoring
Monitors:
- workflow drift;
- retries;
- dead letters;
- stuck executions;
- reconciliation;
- vector maintenance;
- security controls;
- SLOs;
- dependencies.

## WF-20 WooCommerce Gateway
Only privileged commerce boundary.
Enforces:
- fixed operation allowlist;
- fixed endpoint mapping;
- strict parameters;
- credential isolation;
- timeout;
- retry;
- idempotency;
- post-action verification;
- unknown execution handling.
