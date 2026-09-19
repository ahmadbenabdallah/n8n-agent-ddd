# n8n Deployment Model

Recommended deployment groups:

## Customer request path
WF-00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 20

## Asynchronous operational path
WF-17, WF-18, WF-19

Use:
- separate credentials by workflow role;
- environment variables/secrets manager;
- versioned workflow exports;
- controlled production promotion;
- execution correlation IDs;
- queue/outbox for durable asynchronous events.

Critical production paths must not depend synchronously on analytics completion.
