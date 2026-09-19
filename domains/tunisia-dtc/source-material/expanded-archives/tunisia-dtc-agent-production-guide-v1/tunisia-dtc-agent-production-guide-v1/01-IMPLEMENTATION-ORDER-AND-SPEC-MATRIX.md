# Implementation Order & Specification-to-Workflow Matrix

## 1. Purpose

This document prevents a common failure: having many specification documents and workflow JSON files without a controlled implementation sequence.

The specification documents define behavior. n8n implements the runtime. External services provide authoritative transactional truth.

## 2. Canonical hierarchy

```text
00 Master Specification
        ↓
System / Orchestrator / Business / Security
        ↓
Identity / State / Escalation / Tool Contracts
        ↓
Schemas / RAG / Database / n8n architecture
        ↓
Workflow implementation
        ↓
Tests
        ↓
Deployment
```

## 3. Mapping

| Specification | Primary runtime | Secondary runtime |
|---|---|---|
| Master specification | All workflows | Governance |
| System prompt | WF-09 | WF-16 |
| Orchestrator prompt | WF-00–WF-16 | WF-17 |
| KB specification | WF-18 | WF-11 |
| Sales business logic | WF-05 | WF-04/WF-09/WF-16 |
| Tool contracts | WF-10–WF-15 | WF-07 |
| Security policy | WF-01 | WF-10/WF-16/WF-18 |
| Identity | WF-02 | WF-07/WF-10 |
| Conversation state | WF-03 | WF-05/WF-06 |
| Escalation | WF-08 | WF-06/WF-16/WF-17 |
| Output schema | WF-09 | WF-16 |
| Event schema | WF-17 | Every workflow |
| n8n architecture | All workflows | Deployment |
| Data model | Supabase | WF-03/WF-17 |
| Permission matrix | WF-10 | WF-07/WF-12–15 |
| RAG | WF-18/WF-11 | WF-09 |
| Pricing/promotion | WF-13 | WF-11/WF-14/WF-15 |
| Order/post-purchase | WF-07/WF-08/WF-15 | WF-06 |
| Observability | WF-17/WF-19 | All |
| Production readiness | Deployment | All |
| Tunisia test cases | E2E | Regression |
| Red-team suite | Whole system | WF-01/WF-10/WF-16 |

## 4. Workflow dependency graph

```text
WF-00
 └→ WF-01
     └→ WF-02
         └→ WF-03
             └→ WF-04
                 ├→ WF-05
                 ├→ WF-06
                 ├→ WF-07
                 ├→ WF-08
                 └→ WF-09
                     └→ WF-10
                         ├→ WF-11
                         ├→ WF-12
                         ├→ WF-13
                         ├→ WF-14
                         └→ WF-15
                             └→ WF-16
                                 └→ channel sender

WF-18 = independent KB lifecycle
WF-17 = cross-cutting audit
WF-19 = cross-cutting monitoring
```

## 5. Critical dependencies

### WF-09 requires

- system prompt
- orchestrator prompt
- output schema
- trusted context contract
- OpenAI credential
- model configuration.

### WF-10 requires

- identity contract
- permission matrix
- action contracts
- state
- security result
- idempotency storage.

### WF-11 requires

- pgvector
- KB schema
- retrieval RPC
- embedding/indexed documents
- product adapter for dynamic facts.

### WF-12 requires

- commerce cart adapter
- inventory adapter
- idempotency ledger
- authorization contract.

### WF-14/WF-15 require

- cart
- pricing
- inventory
- promotion
- checkout/transaction adapter
- strong idempotency
- post-action verification.

## 6. No hidden dependency rule

Before activating a workflow, document:

```text
INPUT CONTRACT
OUTPUT CONTRACT
DATABASE DEPENDENCIES
CREDENTIALS
EXTERNAL API
RETRY POLICY
TIMEOUT
IDEMPOTENCY
FAILURE PATH
AUDIT EVENT
TESTS
```

If one is unknown, the workflow is not production-ready.
