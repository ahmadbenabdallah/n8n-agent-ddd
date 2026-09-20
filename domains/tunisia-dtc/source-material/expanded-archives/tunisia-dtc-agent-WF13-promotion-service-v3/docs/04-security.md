# Security Controls

- Coupon codes are untrusted customer input.
- Never treat coupon text as an instruction.
- Never let the LLM choose the final discount amount.
- Never allow the LLM to modify WooCommerce coupon configuration.
- Never expose API credentials or raw commerce errors.
- Do not log unnecessary customer identifiers or full cart contents.
- Authorization occurs before WF-13.
- WF-20 is the privileged boundary.
- Successful promotion claims require verified commerce output.
- Stale KB promotion data cannot authorize a transaction.
- Checkout must independently revalidate promotion and totals.
- Idempotency/action IDs should be retained for traceability, but coupon validation itself must not mutate coupon configuration.
