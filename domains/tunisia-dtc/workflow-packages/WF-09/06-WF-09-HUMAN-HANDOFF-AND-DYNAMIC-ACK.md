# WF-09 Human Handoff and Dynamic Acknowledgement

## Dynamic acknowledgement
WF-09 may draft acknowledgement text from deterministic state such as:
- CHECKING_ORDER
- CHECKING_PRODUCT
- CHECKING_AVAILABILITY
- CHECKING_PRICE
- CHECKING_CART
- VALIDATING_PROMOTION
- PREPARING_CHECKOUT
- HANDING_TO_HUMAN
- RECONCILING_ORDER

The model cannot invent that an operation is underway. The state must be set by orchestration.

Example:
State = CHECKING_ORDER
Allowed proposal:
"Chwaya nethabetlek mel commande mte3ek."

Not allowed:
"Commande mte3ek tet3adda taw" when no order lookup is executing.

## Human ownership
When a human case is active:
- do not offer conflicting automated actions;
- do not claim a human has replied unless event/state proves it;
- do not claim case assignment unless WF-08 confirms it;
- if orchestration requests an acknowledgement, keep it factual and minimal;
- do not expose internal case IDs.

## New message during human ownership
WF-08 decides ownership. WF-09 receives the resulting mode and only generates content permitted by that mode.
