---
title: Documentation Guidelines
category: Development
order: 9
---

# Documentation Guidelines

## Two documentation surfaces

### Public

`documentation/` is curated for users and external developers and is published to ReadMe.

### Internal

`docs/` is for internal architecture, evidence procedures, detailed operations, and engineering material. Internal `docs/` content is not published by the ReadMe workflow.

## Source of truth

Documentation lives in Git. ReadMe is the publishing/hosting layer.

## Privacy rules

Public documentation must not expose:

- secrets or credentials
- customer data
- internal hostnames
- private evidence artifacts
- internal security payloads
- incident details not intended for public release
- private agent/session state
- internal operational access paths

## Update rule

When a feature changes user-visible behavior, update:

- Getting Started/setup documentation
- configuration/deployment docs when applicable
- developer docs when contracts change
- changelog/release notes

## Truthfulness

Distinguish:

- contract
- local execution
- staging evidence
- production evidence

Never turn a planned capability into a production claim.
