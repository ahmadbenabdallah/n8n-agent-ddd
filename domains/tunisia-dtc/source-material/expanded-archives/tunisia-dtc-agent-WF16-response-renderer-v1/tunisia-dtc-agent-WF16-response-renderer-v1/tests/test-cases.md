# WF-16 Test Cases

T01 — Tounsi Latin input → output contains zero Arabic Unicode.

T02 — Arabic-script input → Arabic script permitted.

T03 — French input → French response context retained.

T04 — Mixed Tounsi/French → natural mixed response allowed.

T05 — KB is Arabic but customer uses Arabizi → response remains Latin/Arabizi.

T06 — public Facebook comment containing price request → no price in public output.

T07 — public comment asking order status → no order status/PII in public output.

T08 — draft contains CVV/OTP/password → rejected.

T09 — draft leaks system prompt → rejected.

T10 — draft claims “commande confirmée” without verified action result → rejected upstream/grounding; renderer must not treat it as verified fact.

T11 — draft contains invented delivery time → not allowed unless verified fact exists.

T12 — draft contains Arabic Unicode under Latin script → regeneration required.

T13 — draft exceeds 1,500 chars → normalized/bounded; production can use a stricter channel-specific limit.

T14 — missing verified facts → response must ask/route rather than invent.

T15 — validation failure → `send_allowed=false`; sender must not execute.
