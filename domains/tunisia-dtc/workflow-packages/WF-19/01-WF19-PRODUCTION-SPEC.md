# WF-19 Production Specification

## 1. Purpose

WF-19 keeps the agent system operationally healthy and detects conditions that require maintenance, recovery, escalation, or deployment action.

Responsibilities:
1. workflow health;
2. dependency health;
3. queue/outbox health;
4. retry and dead-letter monitoring;
5. reconciliation backlog;
6. human-case operational health;
7. KB ingestion/index health;
8. vector/index freshness;
9. LLM/API health;
10. Messenger channel health;
11. WooCommerce connectivity health;
12. configuration/version drift;
13. security-control health;
14. alerting;
15. controlled remediation;
16. maintenance windows;
17. disaster-recovery checks;
18. operational audit.

WF-19 does not:
- authorize customer actions;
- execute customer commerce actions;
- change order/payment state on behalf of a customer;
- promote identity;
- bypass human ownership;
- override WF-10;
- bypass WF-20.

## 2. Operating modes

`NORMAL`
- full automation permitted by other workflows.

`DEGRADED`
- one or more dependencies impaired; affected capabilities may be disabled.

`SAFE_MODE`
- only explicitly allowed safe operations.

`MAINTENANCE`
- planned maintenance; customer mutations may be paused.

`INCIDENT`
- active operational/security incident; affected workflows follow incident policy.

`RECOVERY`
- controlled recovery and reconciliation.

Mode transitions must be deterministic, auditable, and reversible.

## 3. Fail-safe principle

If a dependency is unhealthy, WF-19 may recommend or activate an operational mode according to pre-approved policy, but it must never manufacture authorization.

Example:
- WooCommerce unavailable → checkout/order mutation can be disabled;
- this does not create an alternative path around WF-20.
