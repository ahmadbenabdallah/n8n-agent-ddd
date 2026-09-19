# WF-18 E2E Acceptance

## A. Approved policy ingestion
Source → validation → approval → published chunks → retrieval with provenance.

## B. Document update
New approved version becomes active; old version becomes superseded.

## C. Rollback
Defective current version → previous approved version republished with audit trail.

## D. Poisoned source
Prompt injection → quarantine → no production retrieval.

## E. Dynamic-data separation
Document says price X → live product price remains authoritative.

## F. Multilingual retrieval
French/Arabic/Tunisian source can be retrieved with provenance; WF-16 controls response language/script.

## G. Duplicate run
Same checksum/source version → no duplicate production chunks.

## H. Embedding failure
Failed embedding → no publication.

## I. Conflicting policies
Conflict → no arbitrary retrieval winner; review required.

## J. Customer-content ingestion
Customer message cannot become approved business knowledge without explicit controlled workflow.

Acceptance requires all security, provenance, versioning, quality and dynamic-data separation tests to pass.
