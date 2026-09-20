# Sensitive Data Boundary

Never render or expose:
- API keys
- access tokens
- WooCommerce consumer secrets
- passwords
- OTPs
- PINs
- PAN/card numbers
- CVV
- Cart-Tokens
- Store API nonces
- internal WordPress/WooCommerce errors
- supplier/internal notes
- fraud/risk internals
- unrelated customer records

Customer-safe delivery details may be rendered only when the application has explicitly authorized them for the current conversation.
