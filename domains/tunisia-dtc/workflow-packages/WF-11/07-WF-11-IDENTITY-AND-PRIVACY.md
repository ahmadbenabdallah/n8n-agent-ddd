# WF-11 Identity and Privacy

Most product information is public.

WF-11 must not use customer identity to expose private information unless explicitly required by an authorized workflow.

Never return:
- another customer's order data;
- customer addresses;
- phone numbers;
- private notes;
- payment information;
- credentials;
- internal WooCommerce metadata.

Identity context may be used only when needed for a permitted operation and should be minimized.
