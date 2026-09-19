# WF-12 Test Cases

## T01 — cart_view authorized
Input: channel_linked identity + authorized `cart_view`.
Expected: adapter request created; success only after verified adapter response.

## T02 — cart_add valid variant
Input: SKU-001, size 42, quantity 1, stock 12.
Expected: commerce request contains SKU, variant, quantity and idempotency key.

## T03 — cart_add missing SKU
Expected: rejected at parameter validation; no adapter call.

## T04 — cart_add invalid quantity
Input: quantity 0 or 100.
Expected: rejected.

## T05 — cart_add insufficient known stock
Input: stock 1, quantity 2.
Expected: rejected before adapter call.

## T06 — cart_update
Input: existing cart + SKU + size 43 + quantity 1.
Expected: validated update request.

## T07 — cart_remove
Input: valid cart line reference/variant.
Expected: removal request; no success until verification.

## T08 — cart_clear
Expected: clear request; no success until verification.

## T09 — anonymous mutation
Input: identity level `anonymous`.
Expected: authorization failure.

## T10 — execution_allowed false
Expected: authorization failure even if action looks valid.

## T11 — duplicate idempotency
Input: same idempotency key already present.
Expected: reject/no duplicate mutation.

## T12 — adapter returns unverified
Expected: `failed`; `execution_allowed=false`.

## T13 — adapter owner mismatch
Expected: `failed`; no cart disclosure.

## T14 — adapter missing
Expected: `awaiting_adapter`; never claim completed.

## T15 — sensitive data in input
Input contains OTP/CVV in arbitrary fields.
Expected: upstream security boundary should have blocked it; WF-12 must not forward such fields.
