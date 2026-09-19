#!/usr/bin/env bash
set -euo pipefail

test -f spec/architecture/blue-green-state.yaml
test -x scripts/production/blue-green-promote.sh
test -x scripts/production/blue-green-retire.sh

grep -q "domain_state: never_slot_local" spec/architecture/blue-green-state.yaml
grep -q "idempotency: shared_durable_state" spec/architecture/blue-green-state.yaml
grep -q "unknown_external_outcomes_are_reconciled_before_retry" spec/architecture/blue-green-state.yaml

echo "PASS: blue/green state contract"
