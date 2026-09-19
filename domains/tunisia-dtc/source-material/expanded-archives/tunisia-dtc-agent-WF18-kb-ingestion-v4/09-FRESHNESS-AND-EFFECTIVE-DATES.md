# Freshness & Effective Dates

Documents may contain temporal validity.

Rules:
- future documents are not active before `effective_from`;
- expired documents are excluded;
- deprecated documents are excluded from normal retrieval;
- overlapping versions require deterministic precedence;
- policy changes require versioned publication.

Dynamic commerce data remains outside the KB.

Example:
A shipping-policy document can explain standard shipping terms.

It must not be used to assert:
- current delivery slot availability;
- current shipping fee;
- current order status.

Those require live service verification.
