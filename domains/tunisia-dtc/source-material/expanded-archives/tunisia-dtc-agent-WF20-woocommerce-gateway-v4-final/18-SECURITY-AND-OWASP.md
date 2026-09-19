# WF-20 Security & OWASP Controls

### Prompt Injection
WF-20 does not interpret natural language.

### Excessive Agency
Only WF-10-authorized operations are accepted.

### Tool Misuse
Operation registry prevents arbitrary endpoints/methods/credentials.

### Sensitive Information Disclosure
Credentials/tokens/payment secrets are blocked from input/output/logs.

### Insecure Output Handling
Raw WooCommerce responses are normalized and filtered.

### Identity Abuse
Order/customer reads require appropriate WF-10 scope authorization.

### Parameter Tampering
Normalized parameter hash is bound to authorization.

### Replay
Idempotency prevents duplicate consequential execution.

### Misinformation
Post-action verification prevents false success.

### Unbounded Consumption
Timeouts, rate limits, request-size limits and bounded retries are enforced.

### Supply Chain
API versions, node versions, schemas and credential integrations are version-controlled.
