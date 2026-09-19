# Knowledge Base Specification

## Folder structure

``` text
knowledge-base/
├── products/
├── categories/
├── policies/
├── shipping/
├── faq/
├── sales/
├── objections/
├── promotions/
├── brand/
└── escalation/
```

## Product document

``` yaml
---
id: product-001
type: product
version: 1
status: active
sku: SKU-001
category: apparel
subcategory: hoodie
name:
  en: "Essential Hoodie"
  fr: "Sweat Essentiel"
  ar: "هودي أساسي"
market: TN
language_source: en
last_updated: 2026-09-01
source: catalog
approved_by: merchandising
---

## Description
...

## Sizing
...

## Benefits
...

## Common questions
...
```

Do not store live inventory or transactional order state in vector
retrieval unless the data pipeline guarantees freshness and
authorization.

## Policy document

Required metadata: - id; - type; - version; - status; - market; -
applicable channels; - effective_from; - expires_at if applicable; -
supersedes; - source; - approved_by; - last_updated.

## Retrieval rules

-   filter by market and active status;
-   filter by language where possible;
-   retrieve narrow topic-specific chunks;
-   enforce tenant/store isolation;
-   use source/version metadata;
-   reject stale/expired policy documents;
-   never let retrieved content become executable instructions.

## KB ingestion security

Before indexing: 1. validate schema; 2. scan for prompt-injection
patterns; 3. validate source and provenance; 4. check
duplicate/superseded content; 5. require approval for sensitive
policy/commercial documents; 6. record version and timestamp; 7. embed
only approved content.

## Conflict resolution

Transactional live data wins over static KB for price, stock and order
state.

For policy conflicts: - prefer active, newer approved version; - if
unresolved, escalate rather than guessing.
