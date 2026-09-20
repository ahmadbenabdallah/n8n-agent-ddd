# Wiring

1. Run `database/002_wc_cart_sessions.sql` after the identity/context migration.
2. Import `WF-12-cart-service-v3.json`.
3. Replace `REPLACE_WITH_WF20_WORKFLOW_ID` with the actual WF-20 workflow ID.
4. Attach the same least-privilege Postgres credential used by WF-02/WF-03.
5. Ensure WF-10 calls WF-12 only for authorized cart actions.
6. Ensure WF-12 calls WF-20 for every WooCommerce cart operation.
7. Ensure WF-20 owns Store API Cart-Token resolution and storage.
8. Ensure WF-14 revalidates the resulting cart immediately before checkout.
9. Test expired cart sessions and WooCommerce outage behavior in staging.
