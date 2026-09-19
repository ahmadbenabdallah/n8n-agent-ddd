# WF-15 Identity and Privacy

Payment information is highly sensitive.

Never expose:
- PAN/card number;
- CVV;
- OTP/PIN;
- bank credentials;
- gateway secrets;
- authorization tokens;
- private transaction metadata.

Order/transaction status requires the appropriate WF-02 identity and order scope.

A customer asking about another person's payment must fail closed.

Customer-visible payment information should be minimized to safe status and necessary next steps.
