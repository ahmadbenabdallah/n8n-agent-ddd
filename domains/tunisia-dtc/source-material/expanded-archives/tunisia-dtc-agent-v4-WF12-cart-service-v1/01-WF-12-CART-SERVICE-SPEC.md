# WF-12 Cart Service Specification

## Responsibilities
WF-12:
- create/retrieve the conversation's cart context;
- view cart;
- add/remove/update/clear items;
- resolve product/variation references through WF-11;
- execute only authorized cart mutations;
- verify resulting cart state;
- return normalized cart facts;
- enforce idempotency and safe replay behavior.

## Boundaries
WF-12 does not:
- authorize actions;
- establish identity;
- grant order scope;
- calculate final checkout totals;
- create orders;
- process payment;
- call arbitrary WooCommerce endpoints;
- accept an LLM-supplied credential/token.

WF-10 is the hard authorization boundary.
WF-20 is the only privileged WooCommerce boundary.
