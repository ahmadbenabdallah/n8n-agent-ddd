# WF-14 Identity and Shipping Validation

Checkout requires the identity/context appropriate to the configured business policy.

Validate:
- customer identity linkage where required;
- required checkout name/contact fields;
- shipping destination;
- supported delivery area;
- shipping method;
- any COD eligibility requirements.

Do not infer or fabricate missing address/contact information.

Public Messenger conversations must not expose private customer information.

If identity conflict or required verification exists:
`VERIFICATION_REQUIRED` / `HUMAN_REQUIRED`.
