# Tunisia DTC Agent — Implementation v2

Implementation blueprint for the n8n-orchestrated DTC sales/support system.

Current OWASP baseline: OWASP Top 10 for LLM Applications 2026, which OWASP describes as its latest edition.

Core rule: the LLM proposes; deterministic application logic authorizes and executes.

Build order:
1. Data/state
2. Channel adapters
3. Security gate
4. Identity
5. Commerce read tools
6. RAG
7. Structured reasoning
8. Action validator
9. Cart/checkout
10. Order support
11. Human handoff
12. Analytics
13. Red team
14. Shadow
15. Canary
