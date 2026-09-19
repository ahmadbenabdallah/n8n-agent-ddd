# WF-06 — Support Engine

## Flow

```text
Intent
 → Topic-specific RAG
 → Live data if required
 → Policy validator
 → LLM answer
 → Grounding validation
 → Response renderer
```

## Grounding priority

`live transactional data > active policy > approved FAQ/product KB > conversation context`

If no authoritative answer:
- do not guess;
- explain that it needs checking;
- escalate when the issue is material or repeated.
