# Identity E2E Flows

## A — New Messenger customer
Inbound → WF-00 → WF-02 creates/links customer → channel identity persists → low-assurance support.

## B — Messenger-originated order
Messenger identity → internal customer → commerce identity → WooCommerce order → relationship persisted → future access requires explicit scope.

## C — Website-originated order
Messenger identity → customer_id → no active scope → minimum verification input → WF-07 bounded candidate discovery → application verification → ACTIVE scope → WF-10 authorization → WF-20 fresh WooCommerce lookup → WF-16 response.

## D — Returning customer
Messenger PSID → customer_id → active scope → WF-10 check → WF-20 current status → response without unnecessarily requesting phone again.

## E — Scope revoked
Revoke → WF-10 denies → safe re-verification path → audit.

## F — Identity conflict
Conflict detected → sensitive operations fail closed → security/human resolution → relationship restored only after resolution.
