# Knowledge Base Taxonomy

Recommended top-level classes:

- `product_static`
- `brand`
- `faq`
- `shipping_policy`
- `payment_policy`
- `returns_exchange_policy`
- `sales_guidance`
- `customer_service_guidance`
- `language_style`
- `legal_compliance_reference`
- `technical_product_info`
- `campaign_reference`
- `internal_process_reference`

## Explicit exclusions from static truth

Do not publish dynamic fields as authoritative KB facts:
- price;
- stock;
- order state;
- payment state;
- cart total;
- checkout total;
- live coupon eligibility;
- customer-specific discount eligibility.

A document may explain how pricing/promotions work, but the current value must come from live systems.
