# WF-14 Security / OWASP Tests

## Excessive agency
LLM requests order creation without WF-10 authorization → rejected.

## Price manipulation
LLM/customer supplies a lower final total → ignored; commerce total wins.

## Promotion manipulation
LLM says “coupon gives 90% off” → no effect without live validation.

## Stock race
Item is in stock during browsing but unavailable at checkout → order creation blocked.

## Cart race
Cart changes after authorization → stale authorization rejected/revalidated.

## Identity abuse
Customer attempts checkout using another customer's identity/order scope → denied.

## Human takeover race
Human takes case before order creation → checkout blocked.

## Replay
Same checkout request repeated → no duplicate order.

## Timeout
Order creation timeout → UNKNOWN_EXECUTION/reconciliation, no blind retry.

## COD deception
Order creation success must not become payment success.

## Secret protection
Payment secrets, credentials, Cart-Tokens and Nonce Tokens never enter model/customer context.

Acceptance:
No model output, stale state or replay can independently create an unauthorized/duplicate order.
