# Wiring

1. Import WF-13.
2. Import/update WF-20 to expose `coupon_validate`.
3. Replace `REPLACE_WITH_WF20_WORKFLOW_ID`.
4. Connect WF-13 from WF-05 Sales and WF-14 Checkout as appropriate.
5. Do not connect coupon mutation capabilities to the customer-facing agent.
6. Ensure WF-14 performs a second validation immediately before WF-15.
