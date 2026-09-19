# Durable State

Critical business state must survive n8n redeployment.

Required state-machine pattern for important external mutations:

REQUESTED
→ AUTHORIZED
→ EXECUTION_STARTED
→ EXTERNAL_MUTATION
→ VERIFICATION
→ COMPLETED

Failures may enter REJECTED or RECONCILIATION_REQUIRED.
