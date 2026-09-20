# Security and Retention

WF-17 must not weaken the system's security boundaries.

- LLM output is not trusted merely because it was logged.
- Audit data is sensitive operational data.
- RLS/service-role access must be reviewed.
- Analytics consumers should receive aggregated or minimally identifying data.
- Define retention periods before production.
- Apply deletion/anonymization policy where required.
- Do not use audit logs as an authorization source.
- Do not let a customer-facing agent query unrestricted audit events.
- Security events should be separately alertable without exposing their payload to the customer.
