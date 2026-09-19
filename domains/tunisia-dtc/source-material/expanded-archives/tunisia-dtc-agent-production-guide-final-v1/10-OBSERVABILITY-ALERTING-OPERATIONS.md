# Observability, Alerting and Operations

## Required correlation

Every inbound turn and mutation path should carry:
- correlation_id
- conversation_id
- customer_id where available
- action_id for mutation
- workflow_id/version
- source IDs for KB facts where relevant

## Metrics

### Funnel
- inbound turns
- product discovery
- product interest
- cart adds
- checkout starts
- checkout confirmations
- orders created
- escalations

### Reliability
- workflow failures
- latency
- WooCommerce availability
- Supabase availability
- OpenAI failures
- webhook failures
- timeout rate
- idempotency conflicts
- post-create verification failures

### Security
- blocked prompt injections
- authorization denials
- identity verification failures
- secret/token redactions
- cross-customer access attempts
- rate-limit events
- suspicious KB ingestion

### Knowledge
- retrieval hit rate
- stale source count
- quarantined documents
- embedding failures
- retrieval latency

## Severity

P0:
- unauthorized order
- duplicate order
- secret/payment exposure
- transaction integrity failure
- cross-customer private-data disclosure

P1:
- WF-20 unavailable
- order post-create verification failure
- database failure affecting authorization/idempotency
- widespread workflow failure

P2:
- KB ingestion failure
- elevated retries
- stale sources
- renderer/security blocks

P3:
- isolated noncritical maintenance issue

## Alerts

Alerts must be actionable and route to an identified operator/support destination.

Avoid alert storms:
- deduplicate
- rate-limit alerts
- include correlation IDs
- include safe diagnostic context
- never include secrets/payment data

## Audit

WF-17 should record enough to reconstruct decisions without storing unnecessary sensitive content.
