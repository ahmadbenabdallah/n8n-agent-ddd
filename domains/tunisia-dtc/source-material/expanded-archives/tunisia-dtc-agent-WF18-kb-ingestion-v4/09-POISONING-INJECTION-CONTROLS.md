# Knowledge Poisoning & Prompt Injection Controls

## Threats

- instructions embedded in documents;
- fake system messages;
- malicious HTML/Markdown;
- hidden text;
- adversarial product descriptions;
- poisoned third-party sources;
- content attempting to reveal secrets;
- content attempting to authorize actions.

## Controls

1. Treat source content as data, not instructions.
2. Strip or isolate executable markup.
3. Detect prompt-injection patterns.
4. Quarantine suspicious documents.
5. Require approval for publication.
6. Preserve provenance.
7. Never allow retrieved content to override system/developer policy.
8. Never allow KB content to establish live price/stock/order/payment truth.
9. Never allow KB content to authorize actions.
10. Audit every publish/unpublish decision.
