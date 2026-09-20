# WF-17 Audit & Analytics v3

WF-17 is the append-oriented audit and analytics layer for the DTC agent.

## Purpose

Capture enough evidence to answer:
- what happened;
- when it happened;
- which workflow/action was involved;
- whether authorization allowed it;
- whether it succeeded;
- which source/version was used;
- whether security flags were raised.

It deliberately does **not** become a secret store or a copy of customer conversations.

## Principle

Audit first, analytics second.

The event is redacted before persistence.
