# Customer Identity — Production v3

## Levels
0 Anonymous — channel/session context; general information.
1 Channel-linked — trusted channel/session; limited personalized support.
2 Order-verified — verified customer/order relationship; order-specific information.
3 High-assurance — additional verification; sensitive operations explicitly authorized.

Identity level is deterministic application state. The LLM cannot promote identity.

## Protected operations
Order-specific retrieval, cancellation/update and other sensitive operations require the required identity/order scope.

## Verification
Order number, name, phone, conversation history and customer claims alone are insufficient proof.

## Data minimization
Expose only fields necessary for the requested operation. Never request passwords, OTPs, card numbers, CVV or authentication secrets.
