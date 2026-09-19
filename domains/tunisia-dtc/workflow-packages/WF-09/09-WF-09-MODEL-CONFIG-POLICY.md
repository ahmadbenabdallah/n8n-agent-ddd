# WF-09 Model and Configuration Policy

## Model selection
Model choice is an operational configuration, not a business authorization mechanism.

Any approved model must support:
- strict structured output;
- bounded context/output;
- deterministic-ish behavior suitable for regression testing;
- no direct credentials/tools;
- logging of model/version/configuration metadata without sensitive prompt content.

## Temperature/randomness
Use low randomness for transactional reasoning. Creative variation is not required for authorization-sensitive proposals.

## Version pinning
Production should pin an approved model identifier/version where the provider supports stable versioning. Model changes require regression tests before promotion.

## Token budgets
Set separate bounded input and output budgets. Prevent unbounded conversation history and retrieval expansion.

## Fallback
If the primary model fails:
- use approved fallback only if it has passed the same security/contract tests;
- otherwise use deterministic safe response;
- never downgrade authorization controls.

## Prompt/version control
Store system/developer prompt versions in source control. Include prompt version in audit metadata, not in customer-visible content.
