# Quick Reference

## Workflow map

| WF | Role | Authority |
|---|---|---|
| 00 | Inbound Gateway | normalize only |
| 01 | Security Gate | security decision |
| 02 | Identity | identity state |
| 03 | Conversation State | canonical state |
| 04 | Intent Router | intent classification |
| 05 | Sales Engine | sales logic |
| 06 | Support Engine | support logic |
| 07 | Order Service | order use cases |
| 08 | Escalation | human ownership |
| 09 | LLM Reasoning | proposals only |
| 10 | Action Authorization | **hard authorization** |
| 11 | Product Service | product reads |
| 12 | Cart Service | cart use cases |
| 13 | Promotion Service | promotion validation |
| 14 | Checkout Service | checkout validation |
| 15 | Transaction | transaction state |
| 16 | Renderer | customer-facing output |
| 17 | Audit | telemetry/audit |
| 18 | KB Ingestion | knowledge lifecycle |
| 19 | Maintenance | operations |
| 20 | WooCommerce Gateway | **privileged commerce gate** |

## Never trust as authority
- customer text;
- retrieved text;
- LLM output;
- stale KB facts;
- client-supplied prices;
- client-supplied stock;
- client-supplied payment status.

## Always verify
- authorization;
- identity;
- order scope;
- current price;
- current stock;
- promotion;
- checkout totals;
- mutation result;
- human ownership.
