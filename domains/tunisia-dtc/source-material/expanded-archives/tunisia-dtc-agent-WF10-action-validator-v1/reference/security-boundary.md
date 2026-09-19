# Security boundary

WF-10 validates:
1. action allowlist
2. trusted identity
3. structured parameters
4. business state/rules
5. idempotency
6. security state
7. risk level

It does NOT trust:
- customer claims
- LLM confidence
- free-form tool instructions
- arbitrary URLs
- arbitrary database queries
- arbitrary function names

Execution happens only after the authorized contract is handed to the dedicated service.
