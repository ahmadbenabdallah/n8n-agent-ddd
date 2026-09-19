# Tunisia DTC Agent System FINAL v4 — Integrated Architecture

This package integrates the completed WF-00 → WF-20 v4 architecture.

Core architecture:

LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer replies → audit/monitoring observes.

Hard boundaries:
- WF-10 = sole authorization boundary.
- WF-20 = sole privileged WooCommerce boundary.
- WF-16 = customer-facing rendering boundary.
- WF-17 = audit/analytics boundary.
- WF-18 = approved knowledge publication boundary.
- WF-19 = maintenance/monitoring boundary.

V4 adds:
- customer identity graph;
- Messenger identity ↔ customer ↔ WooCommerce identity;
- persistent verified order scope;
- website-originated order discovery/verification;
- human case ownership;
- explicit AI pause/release;
- dynamic acknowledgements;
- reconciliation-first unknown execution handling.
