# Customer Identity, Authorization & Privacy

## Verification levels

### Anonymous

Can: - browse products; - ask general policy questions.

Cannot: - access order details; - access private customer information.

### Channel-linked

The platform account/thread is linked to a customer record with
appropriate confidence.

Can access only non-sensitive scoped information.

### Order-verified

Customer identity is verified against an approved order/customer
verification flow.

Can: - retrieve relevant order status; - receive permitted order
information.

### High assurance

Required for sensitive changes if the business permits them.

## Never trust

Do not treat these as proof of identity: - "I'm Ahmed"; - a
customer-provided order number alone; - a phone number typed in chat
without verification; - screenshots unless the workflow explicitly
verifies them.

## PII rules

Public social comments: - no phone; - no email; - no address; - no order
number.

Private channels: - disclose only the minimum necessary fields.

Mask sensitive fields where possible.

## Data minimization

Store only what is needed for: - customer service; - order assistance; -
sales analytics; - fraud/security; - legal obligations.

## Cross-customer isolation

Every order/customer lookup must carry an authorized customer scope
generated outside the LLM.
