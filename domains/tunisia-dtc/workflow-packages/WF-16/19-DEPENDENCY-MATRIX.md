# Dependency Matrix

| Dependency | WF-16 usage | Trust |
|---|---|---|
| WF-03 | state, ownership, language/script | trusted deterministic |
| WF-08 | escalation/human case state | trusted deterministic |
| WF-09 | wording proposal | untrusted |
| WF-10 | authorization/result metadata | trusted policy boundary |
| WF-11 | product facts | verified service facts |
| WF-12 | cart facts/results | verified service facts |
| WF-13 | promotion facts | verified service facts |
| WF-14 | checkout/order result | verified service facts |
| WF-15 | payment/transaction status | verified service facts |
| WF-17 | audit sink | audit only |
| WF-20 | indirect commerce source | privileged boundary |

WF-16 cannot elevate trust for any dependency.
