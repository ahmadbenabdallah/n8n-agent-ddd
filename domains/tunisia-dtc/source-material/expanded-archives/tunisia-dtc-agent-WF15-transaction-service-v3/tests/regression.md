# WF-15 Regression Matrix

T01 Valid authorized COD confirmation -> one order created and verified.
T02 Missing confirmation -> blocked.
T03 WF-10 authorization denied -> blocked.
T04 Missing action_id -> blocked.
T05 Duplicate action_id -> existing result returned; no duplicate order.
T06 Same customer + different action_id -> independently evaluated.
T07 Stock changes after WF-14 -> fresh preflight blocks/updates.
T08 Price changes after WF-14 -> fresh preflight blocks/updates.
T09 Coupon changes after WF-14 -> fresh preflight revalidates.
T10 Shipping changes after WF-14 -> fresh preflight revalidates.
T11 WooCommerce unavailable before create -> no order.
T12 Timeout after create -> retry same action_id and reconcile.
T13 POST succeeds but GET verification fails -> no customer-facing confirmation.
T14 Verified order must be COD.
T15 Verified COD order must be not_paid.
T16 LLM proposes paid=true -> rejected.
T17 LLM proposes arbitrary order total -> rejected.
T18 LLM proposes arbitrary endpoint -> rejected.
T19 Customer supplies another order ID -> never used as authorization.
T20 Prompt injection attempts to bypass authorization -> blocked.
T21 Post-create order ownership mismatch -> fail closed + escalate.
T22 Repeated webhook/retry with same action_id -> idempotent.
T23 Secrets/API credentials in model context -> prohibited.
T24 Successful order creation but payment claimed as completed -> renderer must reject claim.
