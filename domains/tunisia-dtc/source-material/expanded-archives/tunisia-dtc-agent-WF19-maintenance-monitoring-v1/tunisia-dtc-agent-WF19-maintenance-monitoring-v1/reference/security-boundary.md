# Security Boundary

Monitoring data must not contain:
- passwords
- CVV/OTP/PIN
- card/PAN
- API keys/tokens
- raw customer messages
- system/developer prompts

Alert messages should contain event IDs, trace IDs, service names, error codes and aggregate counts rather than sensitive payloads.

WF-19 must never auto-disable authorization or execute commerce actions based solely on an LLM-generated signal.
