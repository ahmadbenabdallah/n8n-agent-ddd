# WF-14 Test Cases

T01 — valid checkout_start with verified identity, non-empty cart, complete shipping and live validation → adapter request.

T02 — anonymous checkout → rejected.

T03 — `execution_allowed=false` → rejected.

T04 — empty cart → rejected.

T05 — missing phone/address/postal code → `needs_customer_data`.

T06 — unsupported/missing payment method → rejected or data-incomplete.

T07 — stale price → `revalidation_required`.

T08 — stale stock → `revalidation_required`.

T09 — stale promotion → `revalidation_required`.

T10 — cart version changed between snapshot and adapter → adapter/verification must fail.

T11 — duplicate idempotency key → no second checkout mutation.

T12 — adapter timeout/missing result → `awaiting_adapter`, never success.

T13 — adapter owner mismatch → failed verification.

T14 — adapter price verification false → failed verification.

T15 — customer includes CVV/OTP → upstream security gate should block; checkout adapter must never receive it.

T16 — customer claims “checkout succeeded” → not trusted without commerce verification.

T17 — checkout_confirm → must still pass live validation and idempotency.

T18 — successful checkout session returned → service reports only verified checkout status; PURCHASED belongs to transaction/order service.
