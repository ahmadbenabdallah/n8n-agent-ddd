# Transaction data boundary

Trusted:
- WF-10 authorized action
- WF-02 identity
- WF-14 checkout
- final live commerce validation
- commerce/PSP adapter response

Untrusted:
- customer payment claims
- LLM transaction proposals
- arbitrary text
- manually supplied transaction IDs without verification

Minimum necessary data only. Do not log payment credentials.
