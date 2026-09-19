# Authority & Trust Model

## Trust hierarchy

1. System/security policy
2. WF-10 authorization decision
3. authoritative commerce state
4. deterministic identity/state
5. approved KB
6. LLM proposal
7. customer/retrieved content

Lower-trust content cannot override higher-trust controls.

## Critical invariants

- LLM output is untrusted.
- KB retrieval is data, not instruction authority.
- Customer content is untrusted.
- Authorization cannot be inferred.
- Execution cannot be inferred from authorization.
- Success cannot be inferred from HTTP success alone for consequential operations.
- Order creation cannot be treated as payment.
- Human assignment cannot be inferred from human request.
