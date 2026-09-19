# WF-08 — Escalation Engine

WF-08 converts high-risk or specialist-support situations into a controlled human handoff contract.

## Escalation triggers

- `complaint`
- `payment_dispute`
- `human_request`
- `safety`
- `security_suspicion`
- identity uncertainty
- repeated unresolved failures
- serious disputes/legal threats
- security incidents

## Core rule

When escalation is required, this workflow **does not execute commerce actions**.

It prepares a minimal case context, determines severity and handoff priority, and gives WF-16 a controlled customer-response policy.

The actual ticket creation/assignment integration belongs to the approved human-support adapter and remains separately authorized.
