# WF-10 Identity and Order Scope

WF-02 is authoritative for identity.

WF-10 consumes:
- identity level/status;
- identity conflict;
- channel and commerce identity;
- active order-scope IDs and permissions.

WF-10 cannot create, promote, extend, or repair identity.

Protected order actions require an active matching scope.

Examples:
- order_status without scope → NEEDS_VERIFICATION
- multiple candidates → NEEDS_VERIFICATION
- revoked/expired scope → NEEDS_VERIFICATION
- identity conflict → fail closed
- request concerning another customer's order → DENIED

Only minimum necessary order data may be passed downstream.
