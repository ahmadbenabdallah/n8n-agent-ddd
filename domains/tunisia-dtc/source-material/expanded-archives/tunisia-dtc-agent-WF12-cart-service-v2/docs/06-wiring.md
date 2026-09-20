# Wiring

1. Import WF-12.
2. Import WF-20.
3. Replace `REPLACE_WITH_WF20_WORKFLOW_ID`.
4. Ensure WF-20 implements the cart operations.
5. Connect WF-11 for pre-mutation product validation.
6. Keep WF-10 as the actual authorization boundary.
7. Connect WF-16 only after verification.
8. Run the regression matrix.

Do not expose WooCommerce Store API session headers/cookies to the LLM.
