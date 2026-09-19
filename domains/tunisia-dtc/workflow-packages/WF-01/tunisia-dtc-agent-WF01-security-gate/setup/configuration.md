# Configuration

## 1. Execute Workflow Trigger
Use this workflow as a sub-workflow called from WF-00.

## 2. Validate Canonical Input
Requires:
- channel
- message_id
- text

If missing, the workflow returns a reject decision.

## 3. Normalize Text Security
Uses Unicode NFKC normalization for security scanning.
The original `text` remains available.

## 4. Input Bounds
Default:
- maximum 12,000 Unicode code points
- maximum 20 unexpected control characters

Adjust only after threat-model review.

## 5. Injection Pattern Scan
The included patterns are a deterministic baseline, not a complete classifier.
Add business-specific attack patterns as testing identifies them.

## 6. Sensitive Data Scan
This detects references to credentials/payment/authentication secrets.
Do not store raw secrets in logs.

## 7. Velocity / Repetition Check
WF-01 expects optional upstream fields:
- `recent_messages`
- `messages_last_minute`

Connect these later to Supabase/Redis/state storage.

## 8. Security Decision
Three routes:
- safe_refusal
- controlled_response
- continue

Safe refusal and controlled response both have `action_execution=false`.

## 9. Security Contract
The output consumed by WF-02 contains:
- status
- route
- flags
- safe_to_reply
- llm_allowed
- tools_allowed
- customer_content_untrusted
