# Retention & Access

Retention should be defined by data class:

1. security events;
2. financial/payment state;
3. operational audit;
4. customer-support case data;
5. analytics aggregates;
6. raw content, if separately approved.

Use the shortest period compatible with operational, legal, contractual and security requirements.

Access should follow least privilege:
- operations: operational events;
- security: security events;
- support: scoped case/order evidence;
- analytics: aggregates/de-identified dimensions;
- engineering: limited diagnostics.

All privileged audit access should itself be auditable.
