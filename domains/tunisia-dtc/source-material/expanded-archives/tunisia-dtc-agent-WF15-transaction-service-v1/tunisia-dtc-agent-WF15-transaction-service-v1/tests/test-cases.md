# WF-15 Test Cases

T01 — valid checkout_confirm + verified live facts + COD → adapter request.

T02 — anonymous identity → rejected.

T03 — `execution_allowed=false` → rejected.

T04 — missing checkout ID → rejected.

T05 — stale price → revalidation_required.

T06 — stale stock → revalidation_required.

T07 — stale promotion → revalidation_required.

T08 — unsupported payment method → rejected.

T09 — raw card number/CVV/OTP/PIN/password supplied → rejected; none reaches adapter.

T10 — duplicate idempotency key → no second transaction.

T11 — adapter timeout/missing response → `awaiting_adapter`; never success.

T12 — owner mismatch → failed verification.

T13 — amount mismatch → failed verification.

T14 — currency mismatch → failed verification.

T15 — adapter status `authorized` → report authorized, not captured/paid unless contract says so.

T16 — adapter status `captured` + all verification flags → paid.

T17 — customer says “payment succeeded” without adapter proof → not trusted.

T18 — LLM proposes order creation → proposal cannot bypass WF-10.

T19 — repeated checkout confirmation with same idempotency key → deduplicated.

T20 — final cart version differs from checkout → transaction must be blocked.
