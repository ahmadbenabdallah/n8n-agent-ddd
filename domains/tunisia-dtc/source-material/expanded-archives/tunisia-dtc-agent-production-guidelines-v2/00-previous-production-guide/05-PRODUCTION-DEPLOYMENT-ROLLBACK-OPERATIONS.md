# Production Deployment, Rollback & Operations Runbook

## 1. Deployment phases

```text
DEV
→ STAGING
→ SHADOW
→ CANARY
→ PRODUCTION
```

## 2. DEV

Purpose:

- build
- debug
- unit tests
- contract tests.

No production customers.

## 3. STAGING

Use realistic but non-production data.

Validate:

- complete workflow chain
- real API contracts
- realistic latency
- failures
- security
- language
- commerce.

## 4. Shadow mode

Where channel/business architecture permits, observe real traffic without allowing automated commerce mutations.

Compare:

```text
predicted intent
proposed answer
proposed action
authorization
```

with expected human behavior.

Do not allow shadow mode to accidentally execute writes.

## 5. Canary

Start with a small controlled percentage.

Monitor continuously.

Abort if:

- security regression
- duplicate commerce action
- transaction verification regression
- severe error spike
- provider instability
- unacceptable hallucination/unsupported-claim rate.

## 6. Production activation

Activation order:

1. Database ready.
2. Monitoring ready.
3. Error workflow ready.
4. KB current.
5. Commerce adapters verified.
6. Channel credentials verified.
7. Internal workflows active.
8. Channel gateway active.
9. Canary enabled.
10. Metrics checked.
11. Expand gradually.

## 7. Rollback

### Channel rollback

Disable inbound automation.

### Action rollback

Disable write actions but keep safe informational support if possible.

### Workflow rollback

Restore last known-good workflow version.

### KB rollback

Restore previous document/index version.

### Commerce rollback

Do not blindly reverse transactions.

First inspect authoritative commerce state and reconcile.

## 8. Incident severity

Suggested:

```text
P0 = active security/financial integrity incident
P1 = major customer/commerce outage
P2 = degraded capability
P3 = non-critical defect
```

Exact definitions should be agreed with the operating team.

## 9. P0 security

```text
stop risky automation
→ preserve audit evidence
→ disable affected capability
→ rotate exposed secrets
→ investigate
→ patch
→ red-team regression
→ staging validation
→ controlled restore
```

## 10. P0 transaction

```text
stop writes
→ inspect transaction ledger
→ query authoritative commerce/PSP
→ reconcile uncertain transactions
→ identify duplicate effects
→ restore only after verification.
```

## 11. KB incident

```text
quarantine bad document
→ disable affected version
→ restore last known-good version
→ re-embed/re-index if needed
→ run retrieval regression
→ restore.
```

## 12. Backups

Back up:

- workflow definitions
- database
- KB source
- deployment configuration
- test suites.

Never store plaintext secrets in backups.

## 13. Disaster recovery

Define:

```text
RPO
RTO
```

for the business.

Test restoration periodically.

A backup that has never been restored is not a proven backup.

## 14. Maintenance

Weekly/monthly review:

- workflow errors
- security events
- failed authorizations
- tool failures
- transaction verification
- KB freshness
- cost
- latency
- escalation rate
- conversion
- unsupported claims.

## 15. Change management

Any change to:

- system prompt
- security policy
- identity rules
- tool permissions
- commerce adapters
- pricing
- promotion rules
- state transitions
- renderer
- KB schema

must trigger the appropriate regression suite.

Version before deployment.

## 16. Kill switch

Maintain a tested operational switch for:

```text
disable automated commerce writes
```

without necessarily disabling all informational support.

The kill switch itself must be access-controlled and audited.
