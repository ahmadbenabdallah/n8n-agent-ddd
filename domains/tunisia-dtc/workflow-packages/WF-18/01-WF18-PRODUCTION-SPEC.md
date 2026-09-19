# WF-18 Production Specification

## Purpose

Create and maintain a trusted, versioned knowledge corpus used by WF-09 retrieval.

WF-18 responsibilities:
1. source registration;
2. source validation;
3. content normalization;
4. document classification;
5. metadata extraction;
6. chunking;
7. embedding generation;
8. vector persistence;
9. publication lifecycle;
10. supersession/retirement;
11. provenance;
12. ingestion audit;
13. poisoning controls;
14. retrieval-quality monitoring.

WF-18 does not:
- authorize customer actions;
- execute WooCommerce operations;
- decide identity;
- determine current stock;
- determine current price;
- determine current order status;
- determine payment status;
- grant discounts;
- override business policy.

## Knowledge classes

### Stable / approved
Examples:
- product descriptions approved for marketing;
- brand information;
- return/exchange policy;
- shipping policy;
- payment-method explanations;
- customer-service FAQ;
- tone/language guidance;
- approved sales guidance.

### Dynamic / live
Must not be treated as static KB truth:
- current stock;
- current price;
- active coupon eligibility;
- current promotion eligibility;
- order status;
- payment status;
- checkout total;
- live shipping availability/fee.

Dynamic facts must come from live commerce services.

## Publication principle

Only `APPROVED` documents/chunks can enter the production retrieval index.

Suggested lifecycle:

```text
DRAFT
 -> VALIDATING
 -> VALIDATED
 -> APPROVED
 -> PUBLISHED
 -> SUPERSEDED / RETIRED
```

Failures:
`REJECTED`, `QUARANTINED`.

A source with suspicious instructions or untrusted provenance must be quarantined rather than published.
