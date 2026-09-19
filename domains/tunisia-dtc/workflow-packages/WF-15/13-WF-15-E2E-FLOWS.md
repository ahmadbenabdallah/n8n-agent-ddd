# WF-15 E2E Flows

## COD order
WF-14 creates and verifies order
→ WF-15 reads payment state
→ `not_paid`
→ WF-16 says order confirmed, payment not yet received.

## Online payment success
Configured payment provider confirms capture
→ WF-15 verifies
→ `PAID`
→ render payment confirmation.

## Payment pending
Provider reports pending
→ WF-15 returns PENDING
→ customer is not told payment succeeded.

## Customer claims payment
Customer says “خلصت”/“I paid”
→ query authoritative source
→ if still pending/not_paid, report verified status, not customer claim.

## Payment dispute
→ WF-08 escalation
→ human ownership
→ no conflicting automated action.

## Timeout
→ UNKNOWN
→ reconciliation
→ verified final status or human recovery.
