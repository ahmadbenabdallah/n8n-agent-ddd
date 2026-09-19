# Security and OWASP LLM / Agent Controls

## Threat model

Treat as hostile:
- customer messages
- retrieved KB text
- product descriptions imported from third parties
- webhook payloads
- tool outputs
- model output
- metadata supplied by external channels

## Required controls

### Prompt injection
Retrieved/customer content is data, not instructions. Delimit it clearly. Never let retrieved text change authorization or tool policy.

### Excessive agency
LLM cannot execute tools directly. WF-10 authorizes bounded operations.

### Insecure output handling
No model output reaches a customer or privileged API without schema validation and downstream validation.

### Data leakage
Redact:
- API keys
- access tokens
- Cart-Tokens
- WooCommerce secrets
- passwords
- OTP/PIN
- PAN/CVV
- internal notes
- unrelated customer data

### Identity abuse
Customer-provided identifiers are not proof of identity. Application verification is required.

### Tool/API abuse
WF-20 has a strict operation allowlist. Endpoint, method, parameters and field sets are controlled by application code/configuration.

### RAG poisoning
WF-18 scans and quarantines suspicious content, versions documents, preserves source IDs and prevents KB content from becoming an authorization source.

### Denial of service
Rate-limit inbound events and expensive LLM/RAG paths. Bound message size, history size, retrieval K, tool calls, retries and execution time.

### Supply chain
Pin and review dependencies, n8n community nodes, Docker images and automation packages. Scan source and images.

## Security decision rule

If security state is unknown for a high-impact mutation, fail closed.

## Secret handling rule

Secrets may be used by the connector/tool layer only. They must never enter:
- LLM context
- customer context
- analytics metadata
- normal execution logs
- error messages

## P0 security incidents

Immediately disable affected mutation capability and preserve evidence when:
- unauthorized order is created
- duplicate orders are created due to idempotency failure
- secret/payment credential is exposed
- cross-customer order data is disclosed
- authorization boundary is bypassed
- transaction integrity is uncertain
