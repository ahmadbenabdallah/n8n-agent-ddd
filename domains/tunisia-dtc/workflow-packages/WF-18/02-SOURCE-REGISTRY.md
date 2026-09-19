# Source Registry

Required source metadata:

```json
{
  "document_id": "kb_doc_123",
  "source_type": "approved_policy",
  "title": "Returns Policy",
  "owner": "business",
  "tenant_id": "store_123",
  "language": "tn",
  "script": "latin",
  "version": "3.1",
  "status": "APPROVED",
  "content_hash": "sha256:...",
  "effective_from": "2026-09-01T00:00:00Z",
  "effective_until": null
}
```

Recommended source types:
- approved_policy
- product_documentation
- faq
- brand_guidance
- shipping_policy
- payment_policy
- support_playbook
- approved_marketing_copy
- sizing_guide
- legal_customer_policy

Avoid using:
- customer messages;
- arbitrary web pages;
- unreviewed generated text;
- third-party claims;
- operational secrets

as authoritative business KB without explicit approval.
