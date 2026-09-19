# WF-19 E2E Acceptance

## A. Healthy system
All critical dependencies pass; mode remains NORMAL.

## B. WooCommerce outage
Commerce mutation path enters approved degraded behavior; no bypass; unknown executions are reconciled after recovery.

## C. Messenger outage
Outbound messages queue/retry without replaying commerce actions.

## D. OpenAI outage
Agent uses approved safe fallback or escalates; no invented facts.

## E. Audit outage
Outbox protects consequential audit events.

## F. Workflow drift
Unexpected production change generates an alert and change-control path.

## G. Stuck execution
Detection → alert → bounded recovery → verification.

## H. Security-control failure
Automation is restricted rather than security controls being bypassed.

## I. KB failure
New publication stops while already approved knowledge remains controlled.

## J. Recovery
Incident → remediation → health validation → reconciliation → explicit return to NORMAL.

All tests must preserve WF-10 and WF-20 boundaries.
