# Authorization

Authorization is a hard boundary.

For the reference commerce runtime:

```text
LLM proposes
  ↓
n8n validates
  ↓
WF-10 authorizes
  ↓
WF-20 executes
```

No other component may substitute for WF-10 authorization.
