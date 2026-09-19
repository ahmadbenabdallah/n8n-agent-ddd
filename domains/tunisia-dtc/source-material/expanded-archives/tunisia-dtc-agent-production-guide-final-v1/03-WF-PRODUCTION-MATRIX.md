# WF-00..WF-20 Production Requirements Matrix

| WF | Responsibility | Hard requirement | Production gate |
|---|---|---|---|
| 00 | Inbound Gateway | Validate channel/webhook envelope, normalize input, establish correlation/idempotency metadata | Replay/duplicate/invalid-envelope tests |
| 01 | Security Gate | Prompt-injection, abuse, secret-like input, rate/risk checks; fail closed on critical security conditions | Red-team + rate-limit tests |
| 02 | Identity | Resolve channel identity; never promote identity from LLM/customer claim | Cross-customer and verification tests |
| 03 | Conversation State | Persist state in Supabase; validate transitions; bounded history | State-concurrency/regression tests |
| 04 | Intent Router | Stable taxonomy and regression handling | Intent regression suite |
| 05 | Sales Engine | Discovery, qualification, recommendation using verified facts | Sales scenario suite |
| 06 | Support Engine | Support policy + verified order context only | Privacy/order-scope tests |
| 07 | Order Service | Read/prepare order operations; never confuse order creation with payment | Order lifecycle tests |
| 08 | Escalation Engine | Human handoff with safe context and reason | Escalation/recovery tests |
| 09 | LLM Reasoning | Structured proposal only; bounded context/tools | Schema, refusal, injection tests |
| 10 | Action Validator | Sole authorization boundary; allowlist operations and fields | Must pass all negative authorization tests |
| 11 | Product Service | Live WooCommerce for dynamic facts; KB fallback only for stable info | Price/stock/outage tests |
| 12 | Cart Service | Store API cart, protected session mapping, post-action verification | Cart TOCTOU/idempotency tests |
| 13 | Promotion Service | WooCommerce validates coupon; final checkout revalidates | Coupon restriction/expiry tests |
| 14 | Checkout Service | Produce verified snapshot, never an order; live validation | Total/stock/coupon drift tests |
| 15 | Transaction Service | Fresh preflight, idempotent COD order creation, post-create verification | Timeout/duplicate-order tests |
| 16 | Response Renderer | Customer-safe verified facts only; script guard | Secret/privacy/language tests |
| 17 | Audit & Analytics | Redacted append-only audit/event model | Redaction/completeness tests |
| 18 | KB Ingestion | Versioned, scanned, quarantined, embedded KB | Poisoning/version/retrieval tests |
| 19 | Maintenance | Health/freshness/reconcile/cleanup/security checks | Failure-injection/alert tests |
| 20 | WooCommerce Gateway | Only privileged commerce boundary; native node + bounded HTTP fallback | Endpoint allowlist/credential isolation tests |

## Global acceptance

A workflow is production-ready only when:
- contract tests pass
- negative/security tests pass
- integration tests pass
- observability exists
- failure mode is defined
- rollback/recovery is documented
- no unresolved P0/P1 defect exists
