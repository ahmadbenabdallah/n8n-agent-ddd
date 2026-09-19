# WF-15 Transaction & Payment Service Specification

## Responsibilities
WF-15:
- represent payment/transaction state;
- retrieve authoritative payment state;
- reconcile ambiguous transaction outcomes;
- normalize payment status;
- support payment-related support flows;
- connect checkout/order state to payment state;
- enforce idempotency around transaction operations where applicable;
- provide verified transaction facts to WF-06/WF-09/WF-16.

## Non-responsibilities
WF-15 does not:
- establish identity;
- grant order scope;
- authorize customer actions;
- invent payment status;
- mark COD orders paid merely because they were created;
- expose payment credentials;
- store/process raw card data unless a future PCI-compliant payment integration explicitly requires a separate compliant boundary.

WF-10 remains authorization boundary.
WF-20 remains privileged WooCommerce boundary.
