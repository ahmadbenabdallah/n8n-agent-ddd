# WF-16 Rendering Pipeline

```text
validated orchestration envelope
        |
        v
[1] ownership / mode gate
        |
        +--> HUMAN_OWNED ----> handoff renderer
        |
        v
[2] outcome classification
        |
        +--> VERIFIED_SUCCESS
        +--> VERIFIED_FAILURE
        +--> UNKNOWN / RECONCILIATION
        +--> READ_ONLY_FACTS
        +--> CLARIFICATION
        |
        v
[3] fact binder
        |
        v
[4] LLM wording proposal (optional)
        |
        v
[5] deterministic policy filters
        |   - privacy
        |   - language/script
        |   - unsupported claims
        |   - forbidden data
        |
        v
[6] final validation
        |
        +--> FAIL --> deterministic fallback
        |
        v
[7] channel adapter
        |
        v
Messenger payload
        |
        v
audit event
```

The LLM is optional at the rendering stage. Deterministic templates should be used for consequential confirmations, payment status, reconciliation, security, and handoff where wording ambiguity could create a false claim.
