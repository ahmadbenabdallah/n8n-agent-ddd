# Final Architecture

```text
CHANNELS
  Messenger
     |
     v
WF-00 Inbound Gateway
     |
WF-01 Security Gate
     |
WF-02 Customer Identity Graph
     |
WF-03 Conversation State
     |
WF-04 Intent Router
     |
 +---+-------------------+
 |                       |
 v                       v
WF-05 Sales Engine    WF-06 Support Engine
 |                       |
 +-----------+-----------+
             v
       WF-09 LLM Reasoning
             |
             v
       WF-10 Authorization
             |
      +------+------+
      |             |
      v             v
  READ PATH      WRITE PATH
      |             |
 WF-11/07/...      WF-12/13/14/15
      |             |
      +------WF-20--+
             |
        WooCommerce
             |
       verification
             |
       WF-16 Renderer
             |
         Messenger

Cross-cutting:
WF-08 Human Escalation
WF-17 Audit & Analytics
WF-18 KB Ingestion
WF-19 Maintenance & Monitoring
```

## Authority model

- Business policy: approved application policy.
- Identity: WF-02 / deterministic identity store.
- Conversation state: WF-03.
- Static knowledge: WF-18 published KB.
- Live commerce: WooCommerce through WF-20.
- Authorization: WF-10.
- Payment state: WF-15 + commerce truth.
- Customer-visible output: WF-16.
- Audit: WF-17.
- Operations: WF-19.
