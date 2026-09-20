# Alert Severity

Suggested severity levels:

**P0 Critical**
- unauthorized order creation detected
- duplicate order creation confirmed
- secret/payment data exposure
- integrity failure in transaction boundary

**P1 High**
- WF-20 unavailable
- order post-create verification failing
- database write failures affecting transaction/idempotency state
- widespread workflow failures

**P2 Medium**
- KB ingestion failures
- rising retry rate
- stale KB sources
- elevated renderer/security blocks

**P3 Low**
- individual informational workflow failure
- non-critical maintenance/cleanup issue

Alert routing and thresholds must be configured in the actual deployment environment.
