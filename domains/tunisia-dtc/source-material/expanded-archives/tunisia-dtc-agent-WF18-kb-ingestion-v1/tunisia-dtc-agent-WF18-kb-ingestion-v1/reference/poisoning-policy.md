# KB Poisoning Policy

Quarantine documents containing suspicious instructions such as:
- ignore previous instructions
- reveal system/developer prompts
- expose secrets
- execute/call tools
- bypass security/policy
- override authorization

This is a heuristic pre-ingestion detector, not a complete security guarantee.

A human/review process should inspect quarantined documents before approval.

Retrieved KB content remains untrusted at runtime and must not override system, business or security rules.
