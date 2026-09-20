# Outage and Recovery

If WooCommerce is unavailable before creation:
- do not create an order;
- preserve purchase intent/customer details in WF-03/Supabase;
- customer-facing response should say the order cannot yet be finalized.

If WooCommerce fails during the creation sequence:
- do not blindly retry with a new action ID;
- retry with the same action ID;
- WF-20 should first reconcile whether an order was already created.

If post-create verification is unavailable:
- do not tell the customer the order is confirmed;
- escalate operationally;
- reconcile using the same action ID/order reference.
