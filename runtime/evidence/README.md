# Evidence

This directory defines the evidence layout; real credentials, customer data,
production data, tokens, and private infrastructure details must never be
committed here.

A local or CI run may write evidence under:

`runtime/evidence/phase-10/runs/<run-id>/`

The generated certification decision belongs at:

`runtime/evidence/phase-10/certification.json`

Use synthetic staging identities and sanitized outputs.
