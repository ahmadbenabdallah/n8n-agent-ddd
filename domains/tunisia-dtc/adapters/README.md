# Tunisia DTC Adapter Model

The Tunisia DTC domain is not permanently coupled to Messenger or WooCommerce.

The current implementation may use:

- Meta Messenger as a channel adapter
- WooCommerce as a commerce adapter

The domain/application contracts remain canonical.

To support another stack, implement the relevant ports and register the
adapter. Do not fork the domain rules.

Examples:

- WhatsApp -> `ChannelPort`
- Shopify -> `CommercePort`
- PrestaShop -> `CommercePort`
- custom commerce API -> `CommercePort`

If the provider cannot satisfy an operation, the adapter must return an
explicit unsupported-capability result rather than silently changing domain
behavior.
