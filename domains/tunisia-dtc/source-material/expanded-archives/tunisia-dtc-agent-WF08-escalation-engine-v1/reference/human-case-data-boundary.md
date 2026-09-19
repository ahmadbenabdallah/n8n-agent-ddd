# Human case data boundary

Include:
- conversation ID
- message ID
- escalation reason
- severity
- minimum identity reference
- current sales/support stage
- selected product/cart reference only when necessary
- concise customer issue

Exclude:
- passwords
- OTPs
- CVV/CVC
- full card numbers
- API keys
- auth tokens
- system/developer prompts
- internal security rules
- fraud scores
- unrelated customer records
- unnecessary private conversation history

The human-support system should receive only what is necessary to resolve the case.
