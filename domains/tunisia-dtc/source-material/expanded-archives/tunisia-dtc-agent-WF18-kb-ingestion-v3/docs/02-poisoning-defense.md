# KB Poisoning Defense

Retrieved KB text is data, not instructions.

WF-18 flags content containing common instruction-injection/secrets patterns and quarantines it for review.

Examples of suspicious content:
- "ignore previous instructions"
- requests to reveal system prompts/secrets
- requests to execute tools
- requests to override authorization/security
- secret-like credential references

Security scanning is defense-in-depth, not proof that content is safe.

A human/admin approval process should exist for external or untrusted sources.
