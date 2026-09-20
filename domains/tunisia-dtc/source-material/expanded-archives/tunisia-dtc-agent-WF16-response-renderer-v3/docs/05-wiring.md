# Wiring

1. Import WF-16.
2. Route verified results from WF-05/WF-06/WF-07/WF-11/WF-12/WF-13/WF-14/WF-15 into the renderer contract.
3. Do not route raw WooCommerce responses directly to Messenger.
4. Preserve WF-03 language/script/register state.
5. Ensure WF-16 only receives verified results.
6. Send only the `customer_message` and approved public metadata to Messenger.
7. Add channel-specific length/rate/template constraints before production.
8. Verify n8n node schemas against the installed n8n version.
