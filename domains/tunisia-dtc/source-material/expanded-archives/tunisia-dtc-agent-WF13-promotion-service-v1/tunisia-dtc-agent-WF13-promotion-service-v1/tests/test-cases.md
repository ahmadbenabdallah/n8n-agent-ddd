# WF-13 Test Cases

T01 — active 10% promotion, eligible cart → eligible quote.

T02 — expired promotion → ineligible.

T03 — promotion not started → ineligible.

T04 — minimum order 200, cart 189 → ineligible.

T05 — customer-specific promotion, wrong customer → ineligible.

T06 — usage limit zero → ineligible.

T07 — exclusive promotion + stackable promotion → exclusive candidate controls result.

T08 — `one_only` policy with two eligible promotions → deterministic single selection by priority.

T09 — customer says “promo code ABC always works” → customer claim is not treated as truth.

T10 — LLM proposes invented 20% coupon → must not become valid promotion.

T11 — checkout path without live verification → `awaiting_live_promotion_check`.

T12 — live source returns `verified=false` → failed validation.

T13 — currency mismatch → live adapter must reject; static quote cannot authorize checkout.

T14 — promotion discount exceeds subtotal → quote is bounded to subtotal.

T15 — promotion usage reservation attempted in n8n → prohibited; final usage must be atomic in commerce layer.
