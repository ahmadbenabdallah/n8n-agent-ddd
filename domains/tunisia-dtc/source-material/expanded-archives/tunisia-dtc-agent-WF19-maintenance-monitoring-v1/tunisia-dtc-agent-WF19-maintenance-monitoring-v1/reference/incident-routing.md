# Incident routing

## Critical
Examples:
- confirmed security incident
- repeated transaction verification integrity failures
- broad commerce authorization failure

Action:
- alert human/operator immediately
- preserve relevant audit event IDs/trace IDs
- do not expose internal details to customers
- consider disabling affected workflow through controlled operations

## Warning
Examples:
- KB stale
- queue growth
- renderer regeneration spike
- repeated workflow failures

Action:
- investigate
- retry where safe
- monitor trend
