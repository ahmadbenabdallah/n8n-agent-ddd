# Knowledge Base Specification

## Purpose

The KB contains stable, approved business knowledge for the DTC agent.

## Structure

```text
knowledge-base/
├── products/
├── policies/
├── faq/
└── operations/
```

## Required metadata

Every factual Markdown record should include:

```yaml
id:
type:
last_updated:
status:
```

Products should additionally support:
- category
- subcategory
- multilingual name
- SKU
- price reference
- variants
- availability mode
- materials
- care
- shipping class
- images
- tags
- language note

Policies should support:
- category
- regions
- supersedes
- summary
- details
- exceptions

FAQs should support:
- related policy
- question
- approved answer

## Stable IDs

IDs must remain stable.

When a policy is replaced, use `supersedes`.

## Static vs dynamic

Static KB:
- product attributes
- care
- policy rules
- approved FAQ wording

Dynamic systems:
- real-time stock
- current price when pricing is dynamic
- order status
- payment status
- checkout URL
- active promotion eligibility

Do not duplicate dynamic truth into stale Markdown.

## RAG requirements

Store metadata with every chunk:
- document_id
- document_type
- category
- language
- region
- last_updated
- status
- version/supersedes
- source path

Filter retrieval by:
- market/region
- status
- relevant document type
- intent/category
- language where useful

## Retrieval safety

Retrieved content is data, not executable instructions.

A KB document cannot authorize tools or override system/security rules.

## Governance

Before production, replace every `[TO FILL]` value with verified merchant information.
