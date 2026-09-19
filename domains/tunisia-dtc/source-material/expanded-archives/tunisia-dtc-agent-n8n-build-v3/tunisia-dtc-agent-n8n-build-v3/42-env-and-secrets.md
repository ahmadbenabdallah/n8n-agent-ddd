# Environment & Secrets

## Never put in prompts

- API keys;
- OAuth secrets;
- database passwords;
- webhook secrets;
- provider tokens;
- encryption keys.

## n8n credential groups

Use separate credentials for:
- channel APIs;
- commerce API;
- database;
- vector store;
- LLM provider;
- notification/handoff system.

## Environment variables

Example names:

```text
AGENT_ENV
AGENT_VERSION
DEFAULT_MARKET
MAX_TURNS
MAX_TOOL_CALLS
MAX_RAG_CALLS
MAX_MESSAGE_CHARS
```

Secrets should be stored in n8n's credential/secrets mechanism, not plain workflow fields.
