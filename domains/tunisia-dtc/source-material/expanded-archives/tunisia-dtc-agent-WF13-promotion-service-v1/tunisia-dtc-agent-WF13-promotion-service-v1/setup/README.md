# WF-13 — Promotion Service v1

Deterministic promotion eligibility and pricing boundary for the Tunisia DTC agent.

## Supported use
- promotion discovery / eligibility
- promotion validation
- pricing with promotion context
- pre-checkout promotion validation
- checkout promotion revalidation

## Core rule
The LLM may suggest a promotion code or explain an already verified promotion. It cannot create, extend, invent, stack, authorize, or mark a promotion as valid.

`LLM proposal → WF-10 authorization → WF-13 evaluation → live promotion source → checkout/commerce final validation`

This workflow intentionally does not mutate orders or carts and never sets `execution_allowed=true`.

## Import
Import `workflow/WF-13-promotion-service.json` into n8n and keep inactive until the live promotion adapter is connected.
