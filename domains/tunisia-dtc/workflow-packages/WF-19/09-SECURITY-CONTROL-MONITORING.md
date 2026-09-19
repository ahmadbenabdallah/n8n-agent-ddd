# Security Control Monitoring

Monitor the health of controls, not just attacks.

Checks:
- WF-10 authorization path reachable;
- no unexpected direct commerce path;
- WF-20 boundary intact;
- secret-scanning pipeline healthy;
- audit pipeline healthy;
- RLS policies present;
- credential expiry;
- webhook signature validation active;
- rate limiting active;
- idempotency storage available;
- human ownership enforcement active;
- privacy validation active;
- language/script validation active.

A failed security control should be treated as an operational incident where required.

Never disable a security gate merely to restore throughput.
