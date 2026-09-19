# Governance

## Project purpose

n8n Agent DDD is an open-source domain-driven autonomous agent platform built around n8n.

Governance exists to protect:

- architectural integrity
- security boundaries
- contributor transparency
- release quality
- compatibility
- long-term maintainability

## Governance principles

### Open development

Design and implementation should be reviewable through public repository artifacts whenever practical.

### Specification before high-impact implementation

Changes that alter platform boundaries, security guarantees, domain contracts or production behavior should be represented in specifications before implementation.

### Security has veto authority

Security-sensitive changes may be blocked until their risks are understood and mitigations are reviewed.

### Evidence over assertion

Runtime maturity and production readiness are based on evidence, not merely the existence of scripts or contracts.

### Backwards compatibility matters

Breaking changes should be explicit, documented and versioned.

## Maintainers

Maintainers are responsible for:

- reviewing pull requests
- maintaining project standards
- approving releases
- protecting security boundaries
- managing project direction
- maintaining contributor access

The active maintainer list should be kept in the repository and/or project organization metadata.

## Decision making

Routine changes may be approved through normal pull-request review.

Architectural changes should document:

- problem
- alternatives considered
- decision
- consequences
- migration/rollback considerations

Architecture Decision Records may be maintained under `docs/decisions/` as the project grows.

## High-impact decisions

The following require explicit maintainer review:

- authorization model changes
- identity model changes
- protected workflow changes
- payment/transaction model changes
- cross-domain access
- secret-handling changes
- production deployment architecture
- destructive migrations
- license changes
- governance changes

## Releases

Release readiness should consider:

- implementation
- tests
- security
- migration requirements
- documentation
- changelog
- operational impact
- rollback
- runtime evidence where applicable

Production certification must not be inferred from repository state alone.

## Changes to this document

Governance changes should be proposed through a pull request and clearly explained in the change description.

Material governance changes should be reflected in the changelog.
