# Monitoring Model

Recommended operational checks:

### Commerce
- WF-20 health
- WooCommerce API reachability
- Store API/cart health
- transaction verification failures
- idempotency reconciliation

### Workflows
- failed executions
- stuck executions
- retry spikes
- execution latency
- webhook failures

### Database
- connection health
- RLS/service-role configuration
- failed writes
- audit growth
- idempotency growth

### Knowledge
- source freshness
- quarantined documents
- embedding failures
- retrieval/index health
- disabled sources

### Security
- authorization denials
- prompt-injection flags
- renderer violations
- repeated suspicious actions
