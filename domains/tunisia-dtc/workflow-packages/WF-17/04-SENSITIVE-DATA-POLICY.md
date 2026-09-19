# Sensitive Data & Logging Policy

## Never log

- payment card data;
- CVV;
- OTP/PIN;
- passwords;
- API credentials;
- OAuth access/refresh tokens;
- WooCommerce API secrets;
- Cart-Tokens;
- Nonce Tokens;
- session secrets;
- hidden system/developer prompts.

## PII

Store only the minimum necessary for operational purposes.

Examples:
- use `customer_ref` rather than duplicating a full profile;
- use hashed contact identifiers for analytics where possible;
- use scoped order references instead of copying complete order payloads;
- redact addresses and phone numbers unless required by a controlled support workflow.

## Message content

Raw customer and LLM content should not be the default audit payload.

If message retention is required:
- apply an explicit retention policy;
- classify the data;
- redact sensitive values;
- restrict access;
- encrypt at rest;
- record access separately.

## Analytics

Aggregations should preferably operate on:
- counts;
- rates;
- durations;
- categories;
- hashes/references;
- non-sensitive dimensions.

Never use audit logs as a hidden data lake for unrestricted customer content.
