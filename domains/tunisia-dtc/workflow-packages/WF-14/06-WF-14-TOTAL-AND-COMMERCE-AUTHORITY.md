# WF-14 Total and Commerce Authority

Final checkout values come from the authoritative commerce path.

WF-14 must not trust:
- LLM-calculated totals;
- cached prices for final order creation;
- stale promotion values;
- customer claims about discounts;
- client-supplied final totals.

Expected order calculation source:
WooCommerce/controlled commerce checkout path through WF-20.

For a customer-facing total:
- use the verified checkout result;
- include currency;
- do not round/recalculate independently unless the deterministic contract explicitly requires it.
