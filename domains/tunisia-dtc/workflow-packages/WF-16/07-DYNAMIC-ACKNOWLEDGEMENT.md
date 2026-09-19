# Dynamic Acknowledgement Layer

Acknowledgement messages are deterministic representations of actual orchestration state.

| State | Meaning |
|---|---|
| CHECKING_ORDER | Order lookup/status is currently executing |
| CHECKING_PRODUCT | Product information lookup is executing |
| CHECKING_AVAILABILITY | Current stock/availability lookup is executing |
| CHECKING_PRICE | Current price lookup is executing |
| CHECKING_CART | Cart retrieval/mutation verification is executing |
| VALIDATING_PROMOTION | Promotion validation is executing |
| PREPARING_CHECKOUT | Checkout preflight is executing |
| HANDING_TO_HUMAN | Human handoff is being processed |
| RECONCILING_ORDER | Unknown order execution is being reconciled |

Do not emit an acknowledgement unless the corresponding operation actually exists in the current execution trace.

The acknowledgement itself must not imply successful completion.
