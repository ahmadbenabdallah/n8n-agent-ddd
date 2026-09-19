# Security & OWASP Control Guide

## Threat classes

- prompt injection;
- sensitive information disclosure;
- supply-chain/KB poisoning;
- excessive agency;
- vector/embedding weaknesses;
- misinformation/hallucination;
- unbounded consumption;
- tool misuse;
- identity abuse;
- insecure output handling.

## Defense in depth

```text
Input security
→ identity
→ bounded retrieval
→ structured output
→ action validation
→ authorization
→ idempotency
→ execution
→ verification
→ audit
```

## Security invariants

1. Customer content cannot become system instructions.
2. Retrieved KB content cannot become system instructions.
3. LLM cannot authorize itself.
4. LLM cannot directly call WooCommerce.
5. WF-10 is the authorization boundary.
6. WF-20 is the privileged gateway.
7. Customer order data requires order scope.
8. Unknown execution is never represented as success.
9. Secrets never enter LLM/customer context.
10. Audit cannot grant permission.
11. Human ownership blocks conflicting automation.
12. Public Messenger responses do not disclose private customer information.

## Sensitive-data controls

Never request/store/log in LLM context:
- PAN;
- CVV;
- OTP;
- PIN;
- password;
- API key;
- WooCommerce secret;
- Cart-Token;
- Nonce Token.

Use redaction and structured telemetry.
