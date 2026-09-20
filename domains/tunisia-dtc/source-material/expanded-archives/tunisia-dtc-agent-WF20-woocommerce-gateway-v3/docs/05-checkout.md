# Checkout / Transaction Boundary

WooCommerce Store API checkout requires a Nonce Token or Cart Token. Its POST checkout endpoint processes the current cart and supports an `expected_total` check that rejects a stale total with a 409 mismatch. citeturn0search2turn0search6

For this COD architecture, WF-15 remains the transaction authorization service.

WF-20 should:
1. obtain the trusted cart token internally,
2. read current checkout/cart state,
3. validate current totals,
4. return a bounded preflight result,
5. create the COD order through the approved order path,
6. return the created order,
7. allow WF-15 to retrieve and verify it again.

Do not set `set_paid=true` for COD.
