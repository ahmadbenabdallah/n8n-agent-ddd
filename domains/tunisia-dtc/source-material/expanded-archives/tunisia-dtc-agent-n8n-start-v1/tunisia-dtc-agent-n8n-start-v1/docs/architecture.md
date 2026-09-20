# Architecture
LLM proposes -> n8n validates/authorizes -> commerce executes -> n8n verifies -> renderer replies.

20 workflows:
WF-00 Facebook Messenger inbound
WF-01 security
WF-02 identity
WF-03 conversation state
WF-04 intent
WF-05 sales
WF-06 support
WF-07 orders
WF-08 escalation
WF-09 LLM reasoning
WF-10 action validator
WF-11 products
WF-12 cart
WF-13 promotions
WF-14 checkout
WF-15 transactions
WF-16 response renderer
WF-17 audit
WF-18 KB ingestion
WF-19 monitoring
