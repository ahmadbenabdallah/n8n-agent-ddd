# WF-03 Security and Race Tests

- ST-01 LLM attempts identity promotion → reject.
- ST-02 LLM fabricates order_scope → reject.
- ST-03 stale worker overwrites HUMAN ownership → reject via concurrency control.
- ST-04 human takeover followed by AI consequential action → blocked.
- ST-05 revoked scope remains in cached state → WF-10 must deny.
- ST-06 UNKNOWN execution rewritten as success → reject.
- ST-07 LLM changes customer_id → reject.
- ST-08 LLM changes automation_mode → reject.
- ST-09 expired state used as live stock/price/order truth → force fresh commerce read.
- ST-10 duplicate inbound event → state/action idempotency prevents duplicate mutation.
- ST-11 identity conflict → protected action blocked.
- ST-12 secret injected into state → reject/redact.
- ST-13 simultaneous human release and inbound message → deterministic versioned state wins; no unsafe action.
- ST-14 acknowledgement says "done" before verified result → fail.
