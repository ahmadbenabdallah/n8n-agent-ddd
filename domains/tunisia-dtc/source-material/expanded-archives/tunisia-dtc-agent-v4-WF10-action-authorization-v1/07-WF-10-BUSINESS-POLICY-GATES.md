# WF-10 Business Policy Gates

WF-10 enforces authoritative business constraints such as:
- quantity limits;
- purchasable product/variation;
- order constraints;
- supported channels;
- COD eligibility;
- escalation-required conditions;
- promotion/checkout prerequisites.

WF-10 does not invent commerce facts.

Authoritative live facts:
- price/stock → commerce;
- promotion validity → WF-13/commerce;
- checkout total → WF-14/commerce;
- payment status → WF-15/commerce;
- order status → WF-07/WooCommerce.

Consequential actions require fresh validation immediately before execution.
