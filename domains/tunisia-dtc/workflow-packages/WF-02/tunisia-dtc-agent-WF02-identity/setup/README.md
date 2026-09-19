# WF-02 — Identity

WF-02 establishes the minimum identity context required for safe customer operations.

It does NOT ask for passwords, OTPs, CVV, card numbers or API secrets.

## Identity levels

### anonymous
No trusted channel-linked identity is available.
Allowed: public information.

### channel_linked
The channel user ID is linked to a customer record.
Allowed: public information, customer profile, cart read/write.
Order access still requires stronger verification.

### order_verified
The customer has completed the approved order verification flow.
Allowed: order read plus normal cart operations.

### high_assurance
A stronger approved verification method has been completed.
May permit checkout/order-write operations when business rules also allow them.

Identity is authorization context, not a reason to expose private data.
