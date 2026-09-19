---
title: Release Process
category: Development
order: 8
---

# Release Process

## Lifecycle

```text
PLAN
→ IMPLEMENT
→ TEST
→ SECURITY REVIEW
→ ARCHITECTURE REVIEW
→ CI
→ MERGE
→ STAGING
→ EVIDENCE
→ CERTIFICATION
→ APPROVAL
→ PRODUCTION
→ VERIFY
```

## Version dimensions

Runtime, business policy, security policy, LLM model/prompt, knowledge base, and database schema are independently versioned.

## Database changes

Prefer:

`EXPAND → MIGRATE → VERIFY → SWITCH → CONTRACT`

Destructive changes require explicit approval and rollback planning.

## Production

A merged pull request does not equal production deployment. Operational and certification gates must be satisfied and explicit approval must be present.

## Documentation release

Feature changes should update the relevant public docs and release notes in the same change where practical. GitHub Actions then publishes approved documentation changes to ReadMe.
