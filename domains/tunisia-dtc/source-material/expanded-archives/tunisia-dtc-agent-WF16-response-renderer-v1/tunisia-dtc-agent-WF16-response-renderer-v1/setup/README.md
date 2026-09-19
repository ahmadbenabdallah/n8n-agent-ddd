# WF-16 — Response Renderer v1

Customer-facing output boundary for the Tunisia DTC agent.

## Purpose

Turns an approved response plan and verified facts into a customer message while enforcing:
- channel rules
- Tounsi/Arabic/French/English language context
- script rules
- public-channel privacy
- no invented facts
- no internal/security disclosure
- no payment secrets
- output length bounds
- final send authorization

## Key principle

The renderer does not decide business truth. It only renders verified facts.

`verified contracts → constrained LLM draft → deterministic output validation → sendable response`

A failed validation must not be sent.
