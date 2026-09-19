# n8n Implementation — WF-20

Suggested structure:

```text
Execute Workflow Trigger
 -> Validate Gateway Envelope
 -> Validate WF-10 Authorization
 -> Lookup Operation Registry
 -> Validate Parameter Schema
 -> Bind Credentials Internally
 -> Build Fixed Endpoint
 -> Execute HTTP/WooCommerce Node
 -> Normalize Response
 -> Post-Action Verification
 -> Classify Execution/Verification
 -> Emit WF-17 Audit Event
 -> Return Typed Result
```

## Important

Do not use an HTTP Request node where the URL is supplied by the LLM.

Use fixed expressions/registry-controlled endpoints.

Do not allow incoming data to select:
- credential;
- host;
- method;
- arbitrary headers.

For native n8n WooCommerce operations, restrict resource/operation selection to the approved registry.
