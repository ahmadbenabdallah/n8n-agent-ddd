# Identity & Order Scope Audit

Audit transitions such as:

```text
ANONYMOUS
 -> CHANNEL_LINKED
 -> COMMERCE_MATCHED
 -> ORDER_VERIFIED
 -> HIGH_ASSURANCE
```

`COMMERCE_MATCHED` is a useful non-privileged state and must not be treated as order authorization.

For order scope record:
- scope reference;
- scope status;
- creation/expiry/revocation event;
- verification method category;
- linked commerce reference;
- correlation ID.

Do not store the raw proof material in audit events.

A failed identity match, collision, ambiguity, expiry, or revocation should be visible in audit analytics without exposing sensitive proof data.
