# Honest Gap Register — What Is Still Missing

This document is intentionally blunt. It prevents the team from confusing a complete workflow design with a production-integrated commerce system.

## 1. Existing

The project already has:

- master specification
- system prompt
- orchestrator prompt
- business logic
- security policy
- identity model
- conversation state
- escalation policy
- tool contracts
- event schema
- KB specification
- RAG/ingestion design
- database model
- n8n architecture
- node-level workflow design
- permission matrix
- pricing/promotion design
- order/post-purchase design
- observability/evaluation
- production checklist
- Tunisia test cases
- red-team suite
- WF-00 through WF-19 implementations.

## 2. Still required for real production

### A. Real commerce adapters

The workflow boundaries exist, but a real deployment needs the actual merchant platform integration.

Required:

- product
- inventory
- pricing
- cart
- promotion
- checkout
- orders
- transaction/payment.

### B. Actual merchant data

The KB specification contains placeholders until verified merchant information is supplied.

Do not use placeholder facts in production.

### C. Real credentials

All providers need environment-specific credentials.

### D. Real channel configuration

The Meta webhook and sender must be configured for the merchant's actual assets.

### E. Human handoff destination

The escalation contract exists; the actual destination must be selected and integrated.

### F. Production database

Staging schemas must be deployed and security-tested against production requirements.

### G. Backups/DR

Need actual backup schedule and restoration test.

### H. Load capacity

Need actual benchmark data.

### I. Alert routing

WF-19 needs real alert destinations.

### J. Governance

Need owners for:

- security
- commerce
- AI quality
- operations
- incidents.

## 3. Unknowns that cannot honestly be invented

The documentation does not by itself determine:

- exact commerce platform
- exact payment provider
- exact Meta product/account configuration
- exact shipping provider
- exact helpdesk
- expected daily message volume
- peak concurrency
- RPO
- RTO
- final promotion policy
- final identity verification mechanism
- final production hosting topology.

These are deployment inputs, not facts that should be fabricated.

## 4. Production gate

Do not mark production-ready until all unknowns above have owners and concrete values.

## 5. Most dangerous false assumptions

Do NOT assume:

- imported n8n workflow = integrated system
- HTTP Request node = correct commerce integration
- API response = verified business result without contract validation
- LLM output = authorization
- KB = live inventory
- order number = identity verification
- transaction authorization = payment capture
- successful HTTP request = successful business operation
- backup creation = disaster recovery
- passing prompt tests = passing agent tests.

## 6. Correct definition

Production readiness means:

```text
Specification
+
Implementation
+
Real integrations
+
Authorization
+
Verification
+
Security testing
+
E2E testing
+
Operational controls
+
Rollback
+
Monitoring
```

All must be present.
