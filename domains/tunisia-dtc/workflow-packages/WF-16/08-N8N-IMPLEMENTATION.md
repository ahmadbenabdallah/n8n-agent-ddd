# n8n Implementation — WF-16

## Suggested node sequence

1. `Webhook / Execute Workflow Trigger`
2. `Normalize Render Envelope`
3. `Validate Required Envelope`
4. `Read Conversation State`
5. `Ownership Gate`
6. `Outcome Classifier`
7. `Fact Binder`
8. `Sensitive Field Strip`
9. `Render Decision`
10. `LLM Wording` (optional, proposal-only)
11. `Deterministic Claim Validator`
12. `Language/Script Validator`
13. `Privacy Validator`
14. `Fallback Renderer`
15. `Messenger Payload Builder`
16. `Response Idempotency Check`
17. `Send Messenger`
18. `Post-Send Audit`

## Critical rule

Do not connect an LLM node directly to:
- WooCommerce;
- Messenger send authorization;
- Supabase privileged mutations;
- WF-20;
- WF-10 authorization.

The renderer receives facts; it does not gain new privileges.

## Pseudocode

```text
input
 -> validate envelope
 -> load state
 -> if HUMAN/PAUSED: render handoff-only
 -> classify outcome
 -> bind verified facts
 -> strip sensitive fields
 -> generate wording proposal if needed
 -> validate claims against facts
 -> validate language/script
 -> validate privacy
 -> if validation fails: deterministic fallback
 -> build Messenger payload
 -> idempotency guard
 -> send
 -> audit
```

## Send failure

If Messenger send fails:
- persist outbound attempt;
- do not rerun commerce actions;
- retry channel delivery independently;
- preserve original `response_id`;
- audit delivery outcome.
