# n8n Workflow Architecture

## Topology

```text
WhatsApp / Instagram / Facebook
            ↓
      WF-00 Inbound Gate
            ↓
      WF-01 Security Gate
            ↓
       WF-02 Identity
            ↓
        WF-03 State
            ↓
      WF-04 Intent Router
          /       \
       Sales     Support
         \         /
          LLM Reasoning
               ↓
       Structured Output
               ↓
      WF-10 Action Validator
         /      |       \
      READ    WRITE     HUMAN
        \       |        /
         Commerce APIs
               ↓
       Response Renderer
               ↓
          Channel Send
               ↓
        Audit + Analytics
```

## Workflow list

- WF-00 Inbound Gate
- WF-01 Security Gate
- WF-02 Identity
- WF-03 State
- WF-04 Intent Router
- WF-05 Sales
- WF-06 Support
- WF-07 Order
- WF-08 Escalation
- WF-09 LLM Reasoning
- WF-10 Action Validator
- WF-11 Product Tools
- WF-12 Cart Tools
- WF-13 Promotion
- WF-14 Checkout
- WF-15 Order Tools
- WF-16 Response Renderer
- WF-17 Audit/Analytics

## n8n implementation rules

### Webhook

Normalize every channel into a canonical message object.

### Idempotency

Generate or derive a stable inbound message ID.

Ignore duplicate webhook deliveries.

### Security

Run deterministic limits before LLM calls.

### Identity

Resolve identity before order-specific retrieval.

### Retrieval

Retrieve only the minimum relevant documents.

### LLM

Use structured output.

### Validator

Treat every proposed action as untrusted.

### Tools

Execute only allowlisted actions.

### Renderer

Apply channel and language rules.

### Audit

Emit security and business events.

## Retry policy

Retries must be bounded and safe.

Never retry a write operation blindly without idempotency.

## Secrets

Store API keys and credentials in n8n credentials/secrets management.

Never place secrets in:
- prompts
- Markdown KB
- logs
- customer messages

## Deployment

```text
offline tests
→ shadow mode
→ canary
→ production
→ rollback/human-only
```

## Initial implementation principle

Do not invent provider-specific node parameters until the channel, commerce, database and messaging providers are selected.
