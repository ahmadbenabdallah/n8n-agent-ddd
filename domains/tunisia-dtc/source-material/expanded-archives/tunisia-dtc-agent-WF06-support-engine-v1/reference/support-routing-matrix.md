# Support routing matrix

| Intent | Retrieval | Transactional lookup | Identity requirement | Route |
|---|---|---|---|---|
| shipping | shipping policy | no | anonymous | support |
| payment | payment policy | normally no | anonymous | support |
| order_status | order status policy | yes | order_verified/high_assurance | support |
| return_exchange | return policy | often yes | order_verified/high_assurance | support |
| complaint | relevant policy | case-specific | case-specific | escalation |
| payment_dispute | payment policy | yes | high assurance / controlled workflow | escalation |
| human_request | none | no | n/a | escalation |
| safety | safety policy | no by default | n/a | escalation |
| security_suspicion | security policy | no | n/a | escalation |

Never use customer-provided order number/name/phone alone as authorization.
