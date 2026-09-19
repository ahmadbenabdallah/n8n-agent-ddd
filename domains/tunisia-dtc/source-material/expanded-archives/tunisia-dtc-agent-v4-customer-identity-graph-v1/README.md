# Tunisia DTC Agent System FINAL v4 — Customer Identity Graph

This package implements Version 4 / Item 1 only: Customer Identity Graph.

Preserved security boundaries:
- WF-10 is the sole authorization boundary.
- WF-20 is the sole privileged WooCommerce boundary.
- The LLM cannot promote identity or grant permissions.
- Matching an identifier is not authorization.
- Protected order data requires an application-established order scope.
- Data minimization remains mandatory.

Graph:
channel identity → internal customer_id → commerce identity → WooCommerce customer_id → verified order_scope

Supports anonymous Messenger users, Messenger-originated orders, and website-originated WooCommerce orders later accessed through Messenger.

This is an implementation contract, not executable n8n workflow JSON.
