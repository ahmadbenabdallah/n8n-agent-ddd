---
title: Operations
category: Operations
order: 1
---

# Operations

The runtime operations loop is:

`OBSERVE → CLASSIFY → DECIDE → ACT → VERIFY → AUDIT → LEARN`

## Health states

- HEALTHY
- DEGRADED
- UNHEALTHY
- UNKNOWN
- MAINTENANCE

## Reconciliation

Reconciliation protects durable mutation state such as:

- orders
- transactions
- carts
- authorizations
- idempotency records

When an external mutation has an unknown outcome, reconcile before retrying.

## Bounded self-healing

Examples of allowed bounded actions:

- restart a disposable worker
- perform a bounded transient retry
- clear a stale lock
- reschedule reconciliation

Examples of forbidden autonomous actions:

- authorize commerce
- change price, stock, or payment state
- bypass WF-10
- blindly retry an unknown commerce mutation
- export or rotate secrets outside the approved process

Human ownership blocks conflicting automation.

## Backups and restore

Backups, restore drills, migration verification, blue/green deployment, drift detection, and self-healing are separate operational gates. Their repository contracts do not imply live evidence.
