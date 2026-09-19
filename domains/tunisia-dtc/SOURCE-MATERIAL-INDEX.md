# Tunisia DTC Source Material Index

`source-material/` holds the historical artifacts produced while designing the Tunisia DTC reference domain: workflow packages (v1–v4), implementation guides and the system integration package. It is **reference material, not canonical**:

| What | Canonical location |
|---|---|
| Executable n8n workflows | `runtime/n8n/workflows/` |
| Workflow specs and contracts | `domains/tunisia-dtc/workflows/WF-xx/` |
| Prompts | `domains/tunisia-dtc/prompts/` |
| Domain contracts | `domains/tunisia-dtc/contracts/` |
| Security policy | `domains/tunisia-dtc/security/` |
| Tests and red-team suite | `domains/tunisia-dtc/tests/` |

## Reference package per workflow

The most complete package for each workflow, under `source-material/expanded-archives/`:

| Workflow | Package |
|---|---|
| WF-00 Inbound Gateway | `tunisia-dtc-agent-WF00-inbound-gateway-v1` |
| WF-01 Security Gate | `tunisia-dtc-agent-WF01-security-gate-v1` |
| WF-02 Customer Identity | `tunisia-dtc-agent-WF02-identity-v1` |
| WF-03 Conversation State | `tunisia-dtc-agent-v4-WF03-conversation-state-v1` |
| WF-04 Intent Router | `tunisia-dtc-agent-WF04-intent-router-v1` |
| WF-05 Sales Engine | `tunisia-dtc-agent-v4-WF05-sales-engine-v1` |
| WF-06 Support Engine | `tunisia-dtc-agent-v4-WF06-support-engine-v1` |
| WF-07 Order Service | `tunisia-dtc-agent-v4-WF07-order-service-v1` |
| WF-08 Escalation Engine | `tunisia-dtc-agent-v4-WF08-escalation-engine-v1` |
| WF-09 LLM Reasoning | `tunisia-dtc-agent-v4-WF09-llm-reasoning-v1` |
| WF-10 Action Authorization | `tunisia-dtc-agent-v4-WF10-action-authorization-v1` |
| WF-11 Product Service | `tunisia-dtc-agent-v4-WF11-product-service-v1` |
| WF-12 Cart Service | `tunisia-dtc-agent-v4-WF12-cart-service-v1` |
| WF-13 Promotion Service | `tunisia-dtc-agent-v4-WF13-promotion-service-v1` |
| WF-14 Checkout Service | `tunisia-dtc-agent-v4-WF14-checkout-service-v1` |
| WF-15 Transaction / Payment | `tunisia-dtc-agent-v4-WF15-transaction-payment-v1` |
| WF-16 Response Renderer | `tunisia-dtc-agent-WF16-response-renderer-v4` |
| WF-17 Audit & Analytics | `tunisia-dtc-agent-WF17-audit-analytics-v4` |
| WF-18 Knowledge Base Ingestion | `tunisia-dtc-agent-WF18-kb-ingestion-v4` |
| WF-19 Maintenance & Monitoring | `tunisia-dtc-agent-WF19-maintenance-monitoring-v4` |
| WF-20 WooCommerce Gateway | `tunisia-dtc-agent-WF20-woocommerce-gateway-v4-final` |

Older versions of each package sit alongside these under the same folder.

## Other material

- `source-material/FULL-IMPLEMENTATION-GUIDE-v5/`: complete v5 implementation guide.
- `source-material/expanded-archives/tunisia-dtc-agent-system-FINAL-v4-integration/`: final v4 system integration package.

The original zip files are kept in git history; release zips are on the GitHub release `archive-v0.13.0-v0.20.3`.
