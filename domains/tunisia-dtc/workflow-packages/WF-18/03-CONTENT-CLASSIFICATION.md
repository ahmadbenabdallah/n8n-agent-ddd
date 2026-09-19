# Content Classification

Classify each source/chunk before indexing.

Required labels:

- `FACTUAL_BUSINESS_KNOWLEDGE`
- `POLICY`
- `PRODUCT_CONTENT`
- `MARKETING_COPY`
- `PROCEDURE`
- `UNTRUSTED_EXTERNAL`
- `CUSTOMER_CONTENT`
- `SENSITIVE`
- `REJECTED`

## Rules

`CUSTOMER_CONTENT` is never automatically promoted to authoritative business knowledge.

`UNTRUSTED_EXTERNAL` may be used for research only if an explicit workflow allows it; it must not silently become customer-facing business truth.

`SENSITIVE` content must be excluded from ordinary retrieval unless a dedicated access policy permits it.

`REJECTED` content is not embedded into the production retrieval index.
