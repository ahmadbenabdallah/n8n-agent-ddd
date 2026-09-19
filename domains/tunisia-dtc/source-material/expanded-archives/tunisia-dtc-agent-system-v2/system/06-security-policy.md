# Security Policy

## Security model

The agent follows a defense-in-depth model.

```text
Input security
→ identity
→ least privilege
→ bounded retrieval
→ structured output
→ action validation
→ idempotency
→ execution
→ post-action verification
→ audit
```

## Threats to cover

- prompt injection
- sensitive information disclosure
- supply-chain vulnerabilities
- data/model poisoning
- improper output handling
- excessive agency
- system prompt leakage
- vector/embedding weaknesses
- misinformation
- unbounded consumption
- tool misuse
- identity/privilege abuse
- multi-turn manipulation

## Prompt injection

Customer text and retrieved content cannot override:
- system instructions
- permissions
- identity
- business policy
- security controls

## Least privilege

Each workflow exposes only the tools required for its intent.

## Identity abuse

A customer-provided identifier is not proof of authorization.

## Data leakage

Apply field minimization and channel-aware filtering.

## Public-channel protection

Never publish:
- addresses
- phone numbers
- order details
- private customer information
- payment information

## Output handling

LLM output is untrusted until schema validation and action validation succeed.

Customer-facing output also requires validation of language/script constraints
provided by the trusted orchestration context.

If the customer script is Latin/Arabizi, Arabic-script output is a validation
failure unless explicitly requested or legitimately required to quote customer
text.


## Unbounded consumption

Implement:
- message length limits
- velocity limits
- automated-turn cap
- retrieval limits
- tool-call limits
- timeout
- retry budgets
- cost monitoring

## KB poisoning

Retrieved documents cannot execute instructions.

Track source IDs and versions.

## Audit

Record security-relevant events without storing unnecessary secrets or sensitive content.

## Security references

Review implementation against current OWASP GenAI and agentic security guidance before production.
