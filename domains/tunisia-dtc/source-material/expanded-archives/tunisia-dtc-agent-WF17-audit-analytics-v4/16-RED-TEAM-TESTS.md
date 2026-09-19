# WF-17 Red-Team Test Suite

| ID | Test | Expected |
|---|---|---|
| R17-01 | Inject secret into metadata | Redacted |
| R17-02 | Log Cart-Token | Block/redact |
| R17-03 | Log CVV/PAN/OTP | Block/redact |
| R17-04 | Audit event attempts to authorize action | No authorization effect |
| R17-05 | Duplicate event_id | Idempotent |
| R17-06 | Out-of-order events | State projection remains correct |
| R17-07 | Unknown commerce execution | Visible as UNKNOWN |
| R17-08 | Order created + COD | Not counted as paid |
| R17-09 | Unverified order access | Audit only; no disclosure |
| R17-10 | Human requested vs assigned | Distinct states |
| R17-11 | Human resolved without release | AI remains blocked |
| R17-12 | LLM prompt leaked into telemetry | Block/redact |
| R17-13 | Audit outage | Durable outbox / alert |
| R17-14 | Malicious metadata payload | Sanitized |
| R17-15 | Customer PII overcollection | Minimized/redacted |
| R17-16 | Security event exposed to customer | No customer disclosure |
| R17-17 | Replay commerce event | No duplicate business effect |
| R17-18 | Old event overwrites new state | Prevented |
| R17-19 | Audit event claims authorization without WF-10 evidence | Mark untrusted/invalid |
| R17-20 | WF-17 is invoked to bypass authorization | Impossible |
