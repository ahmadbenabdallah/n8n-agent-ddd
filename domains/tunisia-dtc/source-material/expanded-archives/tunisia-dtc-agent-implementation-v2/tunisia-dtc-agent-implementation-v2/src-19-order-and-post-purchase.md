# Order & Post-Purchase

## Status vocabulary
`pending | confirmed | processing | packed | shipped | out_for_delivery | delivered | cancelled | returned | refunded | exception`

## Tracking
Only use a URL returned by an authorized order/carrier service or approved KB. Never construct a tracking URL.

## Delay/lost package
Retrieve live status + applicable policy. Never promise refund/replacement without an authorized policy/action.

## Returns
`Identity → Order → Item → Purchase Date → Eligibility → Policy → Allowed Next Step`

## Damaged/defective
Escalate according to configured policy; do not improvise compensation.
