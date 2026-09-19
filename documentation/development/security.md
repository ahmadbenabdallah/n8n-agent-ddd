---
title: Security Guidelines
category: Development
order: 6
---

# Security Guidelines

## Never expose sensitive payment/authentication data

Do not place these in LLM or customer-visible context:

- PAN
- CVV
- OTP
- PIN
- passwords
- API keys
- provider secrets
- WooCommerce secrets
- cart tokens/nonces

## Authorization

MCP capability discovery, tool visibility, or workflow access never grants business authorization.

Commerce authorization is enforced by WF-10.

## Secret handling

Secrets must be:

- injected at runtime
- excluded from Git
- excluded from durable agent session state
- excluded from evidence artifacts
- excluded from customer messages
- excluded from doctor/status output

## Security changes

Security-sensitive changes require threat-model review, targeted tests, relevant red-team coverage, architecture review, and release evidence.
