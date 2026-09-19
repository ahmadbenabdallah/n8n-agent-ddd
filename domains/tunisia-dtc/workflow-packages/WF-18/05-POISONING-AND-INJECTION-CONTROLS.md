# KB Poisoning & Prompt-Injection Controls

Retrieved documents are data, not instructions.

A document must never be allowed to change:
- system policy;
- authorization;
- identity requirements;
- security policy;
- tool permissions;
- escalation rules;
- output constraints.

## Detection examples

Quarantine sources containing:
- instructions to ignore system rules;
- requests to reveal secrets;
- tool/API execution instructions;
- fake policy overrides;
- credential requests;
- suspicious hidden text;
- encoded prompt injection;
- claims of authority without approved provenance.

## Provenance

Every production chunk must preserve:
- source_id;
- document version;
- chunk_id;
- approval state;
- effective dates;
- ingestion run.

WF-09 should receive provenance references with retrieved context.
