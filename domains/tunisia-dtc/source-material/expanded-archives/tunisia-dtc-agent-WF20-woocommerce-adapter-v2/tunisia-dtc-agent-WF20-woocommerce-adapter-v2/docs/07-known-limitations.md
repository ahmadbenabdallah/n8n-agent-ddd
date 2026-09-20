# Known Limitations / Honesty Notes

1. The native n8n WooCommerce node currently exposes Customer, Order and Product resources according to n8n's published integration page. This package does not invent undocumented operations.

2. The exact node field names/schema can differ across n8n releases. After import, verify the native node UI and pin sample data before activation.

3. The WooCommerce node is not the same thing as a complete conversational cart system. WF-12 remains responsible for agent cart state.

4. HTTP Request is intentionally retained only for the explicit health/fallback path.

5. COD means payment is deferred to delivery. An order created by the API is not proof that cash was collected.

6. Manual shipping is intentionally not automated.

7. The trigger workflow is separate from the synchronous commerce adapter because asynchronous WooCommerce events should not silently authorize agent actions.
