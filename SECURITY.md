# Security Policy

## Scope

This policy covers the n8n Agent DDD repository, its platform contracts, reference domain implementation, workflow architecture, Harness control plane and documented deployment/runtime components.

## Security principles

The project is designed around:

- least privilege
- explicit authorization
- identity assurance
- domain isolation
- secret isolation
- deterministic validation
- idempotency
- reconciliation
- auditability
- bounded autonomy
- human escalation

The LLM is not an authorization mechanism.

## Critical boundaries

### WF-10 — Action Authorization

WF-10 is the hard authorization boundary for consequential actions.

An LLM proposal does not constitute authorization.

### WF-20 — Commerce Gateway

WF-20 is the privileged commerce integration boundary for the Tunisia DTC WooCommerce reference implementation.

### Harness

Harness is a developer/AI control plane. It must not bypass runtime authorization, protected workflow policy or production approval gates.

## Sensitive information

Never commit or expose:

- API keys
- passwords
- access tokens
- private keys
- database credentials
- n8n encryption keys
- WooCommerce secrets
- payment card data
- CVV
- OTP/PIN values
- customer private data
- production credentials

Do not put secrets into prompts, knowledge-base documents, logs or evidence artifacts.

## Reporting a vulnerability

Please do not disclose security vulnerabilities through public GitHub issues.

Use the repository's configured private security advisory or security contact channel.

If a private reporting mechanism has not yet been configured, maintainers should configure GitHub private vulnerability reporting before the project accepts public production use.

When reporting, include:

- affected component
- affected version/commit
- vulnerability description
- reproduction steps
- impact
- suggested mitigation, if known
- whether exploitation is currently observed

Avoid including secrets or real customer data in the report.

## Response process

Maintainers should:

1. acknowledge receipt;
2. validate and triage the report;
3. determine affected versions;
4. assess severity and exploitability;
5. develop and test a mitigation;
6. coordinate disclosure;
7. release the fix where appropriate;
8. document the security change.

Do not publish exploit details before an appropriate remediation/disclosure decision.

## Security-sensitive changes

Changes affecting any of the following require security review:

- authorization
- identity
- permissions
- secrets
- protected workflows
- commerce mutation
- payment/transaction handling
- domain isolation
- external tool access
- MCP policies
- Harness production gates
- self-healing behavior

## Security testing

The repository includes security and red-team testing areas covering, among other cases:

- prompt injection
- retrieved-content injection
- forged authorization
- scope escalation
- cross-customer access
- cross-domain access
- protected workflow mutation
- secret exfiltration
- sensitive-data logging
- arbitrary endpoint use
- price/stock/payment manipulation
- authorization replay
- human-ownership conflicts
- malformed input
- credential leakage
- audit tampering

## Production claims

A passing repository contract is not equivalent to a live security certification.

Production security claims require captured runtime evidence through the project's certification process.
