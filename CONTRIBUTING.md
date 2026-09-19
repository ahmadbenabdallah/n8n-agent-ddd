# Contributing to n8n Agent DDD

Thank you for contributing to n8n Agent DDD.

The project is a domain-driven autonomous agent platform, so contributions are evaluated not only as code changes but as changes to contracts, domain behavior, security boundaries and operational behavior.

## Before you start

Please read:

- `README.md`
- `SECURITY.md`
- `GOVERNANCE.md`
- the relevant `spec/` contracts
- the relevant public documentation

For architecture-sensitive changes, inspect the relevant architecture documents under `docs/`.

## Contribution areas

Contributions are welcome in:

- platform architecture
- domain packs
- n8n workflows
- provider adapters
- channel adapters
- Harness
- agent skills and policies
- testing
- security
- deployment and operations
- documentation
- developer tooling

## Development lifecycle

Use the project's AI-SDLC lifecycle where applicable:

```text
DISCOVER
→ DEFINE
→ DOMAIN
→ SPECIFY
→ ARCHITECT
→ DESIGN
→ DECOMPOSE
→ PLAN
→ IMPLEMENT
→ TEST
→ SECURITY
→ REVIEW
→ INTEGRATE
→ DEPLOY
→ VERIFY
→ OPERATE
→ LEARN
```

## Making a change

1. Identify the affected specification and contracts.
2. Define the intended behavior and acceptance criteria.
3. Create a focused branch/worktree.
4. Implement the smallest coherent change.
5. Add or update tests.
6. Run architecture validation when boundaries are affected.
7. Run security validation for security-sensitive changes.
8. Update documentation and changelog entries when behavior changes.
9. Verify that protected workflow and authorization invariants remain intact.
10. Open a pull request with a clear explanation of the change.

## Domain changes

Domain logic belongs in the relevant domain pack.

Avoid coupling domain behavior directly to a provider when a port/adapter boundary is appropriate.

For the Tunisia DTC reference domain, preserve the distinction between:

- customer identity
- conversation state
- business policy
- LLM reasoning
- authorization
- commerce execution
- provider verification
- audit
- reconciliation

## n8n workflow changes

When modifying a protected workflow, especially:

- WF-01 Security Gate
- WF-10 Action Authorization
- WF-15 Transaction/Payment
- WF-20 WooCommerce Gateway

include the relevant security and architecture impact in the pull request.

Never use an n8n workflow change to bypass platform authorization or provider verification.

## AI-assisted contributions

AI coding agents are supported.

AI-generated changes must still satisfy the same requirements as human-authored changes.

Do not provide AI agents with production secrets or unrestricted production access.

The Harness control plane is designed to route AI-assisted work through specifications, tests, security checks and review gates.

## Pull requests

A good pull request should explain:

- What changed?
- Why was it needed?
- Which specifications/contracts changed?
- Which workflows/domains are affected?
- What tests were run?
- What security implications exist?
- Are migrations required?
- Is rollback required?
- Does public documentation need updating?

Keep pull requests focused and reviewable.

## Commit and release hygiene

Use clear commit messages.

Do not commit:

- credentials
- API keys
- production configuration containing secrets
- customer data
- payment data
- private runtime evidence
- generated artifacts that are not intentionally versioned

## Documentation

Public documentation belongs in the public documentation surface.

Internal engineering material belongs under `docs/`.

The project uses a dedicated public documentation repository for the intended ReadMe bi-directional sync architecture.

## Security issues

Do not open a public issue for a suspected security vulnerability.

Follow `SECURITY.md`.

## License

By contributing, you agree that your contribution is provided under the repository's Apache License 2.0 terms, subject to any separate written agreement applicable to your contribution.
