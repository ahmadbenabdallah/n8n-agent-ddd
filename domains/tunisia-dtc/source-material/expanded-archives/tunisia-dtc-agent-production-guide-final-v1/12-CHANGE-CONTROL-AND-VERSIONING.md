# Change Control and Versioning

## Version every production contract

Version:
- workflow JSON
- input/output schemas
- Supabase migrations
- prompts
- tool contracts
- KB source versions
- WooCommerce gateway operation contracts
- security rules
- renderer templates

## Change classes

### Safe
Documentation-only or non-executable metadata changes.

### Controlled
Prompt, retrieval, renderer, business-rule or noncritical workflow changes. Requires regression tests.

### High risk
Changes to:
- WF-10 authorization
- WF-15 order creation
- WF-20 gateway
- identity verification
- payment/order semantics
- database idempotency
- customer data isolation
- security controls

High-risk changes require full E2E + red-team regression before release.

## Migration compatibility

For database changes, prefer backward-compatible rollout:
1. add new field/table
2. deploy readers/writers
3. migrate data
4. remove obsolete path only after verification

## Prompt changes

A prompt change is a production code change.

Run:
- schema regression
- instruction-hierarchy tests
- prompt-injection suite
- representative sales/support cases
- language/script tests

## Rollback rule

Every release must identify:
- previous known-good version
- migration state
- rollback procedure
- reconciliation procedure if commerce mutations already occurred
