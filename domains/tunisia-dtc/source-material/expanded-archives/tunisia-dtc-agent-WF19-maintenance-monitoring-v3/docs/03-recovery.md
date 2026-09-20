# Recovery

WF-19 should detect and coordinate recovery, but bounded workflows remain responsible for their own business recovery.

Examples:

- WooCommerce outage → WF-19 detects; WF-11/12/13/14/15 continue to fail closed; KB sales conversation may continue.
- Transaction timeout → WF-15/WF-20 reconcile using the same action ID.
- KB source poisoning → WF-18 quarantine/disable source; WF-17 records event.
- Database failure → do not fabricate successful identity/cart/order state.
- n8n execution failure → retry only when the workflow's idempotency contract allows it.

Never implement "automatic retry everything" at the maintenance layer.
