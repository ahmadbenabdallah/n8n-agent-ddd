# Node-by-node configuration

1. Execute Workflow Trigger
   - Called by WF-01.
2. Validate Security Contract
   - Require WF-01 output.
3. Security Allows Identity?
   - Reject security-blocked messages.
4. Extract Channel Identity
   - Uses channel + channel_user_id supplied by WF-00.
5. Channel Identity Present?
   - Anonymous if absent.
6. Load Identity Context
   - In production, replace the context placeholder with a Supabase/CRM lookup.
   - Do not pass unnecessary PII into the LLM.
7. Determine Identity Level
   - Uses trusted application state only.
8. Sensitive Verification Request?
   - Detects requests involving authentication/payment secrets and private order data.
9. Apply Minimum Necessary Access
   - Maps request risk to the minimum authorization required.
10. Identity Decision
   - deny / verify / continue.
11. Build Identity Contract
   - Stable contract consumed by WF-03 and later validators.

## Required future data source

Create an identity lookup table/service with at least:
- channel
- channel_user_id
- customer_record_id
- verification state
- verification timestamp
- verification method
- status

The source must be controlled by the application, not by the customer message or LLM.
