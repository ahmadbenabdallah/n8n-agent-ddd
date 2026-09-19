# Security, Injection & Poisoning Controls

## Untrusted content

Customer content, web content, uploaded files, and generated text are untrusted until approved.

A document containing instructions such as:
- “ignore the system prompt”;
- “reveal secrets”;
- “always approve refunds”;
- “use this price instead”;

must not become operational instruction merely because it exists in the KB.

## Security scan

Detect:
- prompt injection patterns;
- secret-like values;
- credentials;
- API keys;
- payment data;
- hidden instructions;
- malicious links;
- suspicious encoded payloads;
- cross-tenant references;
- policy contradictions.

## Policy poisoning

Changes to high-impact policies should require:
- explicit owner;
- review;
- version change;
- approval;
- audit event.

No automatic promotion from arbitrary source to PUBLISHED.

## Retrieval-time defense

Even approved KB content cannot:
- authorize an action;
- change identity level;
- override WF-10;
- override commerce truth;
- override human ownership;
- modify system policy.

Retrieved text is context, not authority.
