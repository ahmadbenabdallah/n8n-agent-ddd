# Tunisia DTC AI Sales & Support Agent

This package turns the initial three prompt/KB files into a
production-oriented specification for an n8n-orchestrated DTC sales and
support agent.

## Key architectural decision

The LLM is a reasoning and communication component. It is not the
business authority.

n8n/application services control: - identity; - permissions; -
inventory; - pricing; - promotions; - order access; - writes; -
escalation; - limits; - audit.

## Language

The primary conversational market is Tunisia: - Tounsi; - Arabic; -
French; - English.

## Security

The design uses the latest OWASP GenAI/LLM Top 10 initiative as the
security baseline, with explicit controls for the LLM01--LLM10
workstreams and a compatibility mapping to the 2025 taxonomy.

## Implementation order

1.  Define commerce backend integrations.
2.  Implement state store.
3.  Implement security/identity gate.
4.  Implement KB ingestion and retrieval.
5.  Implement read-only product/order tools.
6.  Implement structured LLM output.
7.  Implement action validator.
8.  Implement cart/checkout.
9.  Implement human handoff.
10. Run red-team suite.
11. Enable production traffic gradually.
