# WF-18 E2E Acceptance

## A. Approved FAQ
Source → validation → embedding → publication → retrieval with provenance.

## B. Policy update
New version → review → publish → old version no longer active.

## C. Rollback
Bad release → known-good version restored → audit preserved.

## D. Injection
Malicious document → security scanner → quarantine → no production retrieval.

## E. Dynamic price
KB contains old price → runtime must use live commerce price.

## F. Dynamic stock
KB contains stock statement → runtime must use WF-11/WF-20 live stock.

## G. Tenant isolation
Store A query cannot retrieve Store B content.

## H. Language/script
Retrieval metadata supports the request but WF-16 controls final output script.

## I. Contradiction
Two conflicting approved sources → deterministic conflict handling / review.

## J. Idempotency
Same source/version ingested repeatedly → one logical published version.
