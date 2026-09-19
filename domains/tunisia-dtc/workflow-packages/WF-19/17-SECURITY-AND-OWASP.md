# WF-19 Security & OWASP Controls

### Prompt Injection
Monitoring never treats customer/KB content as operational instructions.

### Sensitive Information Disclosure
Logs and alerts are redacted.

### Excessive Agency
WF-19 has no customer commerce authority.

### Tool Misuse
Maintenance actions use allowlisted operational capabilities.

### Unbounded Consumption
Health checks, retries and scans have bounded concurrency and frequency.

### Insecure Configuration
Configuration/version drift is monitored.

### Authorization
WF-10 remains the only authorization boundary.

### Audit
WF-17 remains the audit system; WF-19 consumes audit signals but does not rewrite evidence.

### Recovery safety
Unknown commerce states require authoritative reconciliation.

### Security degradation
Security controls fail closed. Operational recovery cannot disable them silently.
