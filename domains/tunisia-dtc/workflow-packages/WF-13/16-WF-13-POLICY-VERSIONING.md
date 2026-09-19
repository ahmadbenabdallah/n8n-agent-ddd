# WF-13 Policy and Promotion Versioning

Promotion business rules must be versioned/configured outside the LLM.

Audit metadata should include:
- promotion/policy identifier;
- policy version;
- validation timestamp;
- source;
- correlation ID.

Changes to promotion policy require regression tests covering:
- eligibility;
- restrictions;
- expiry;
- usage limits;
- checkout interaction.

Historical audit records must remain interpretable after policy changes.
