#!/usr/bin/env bash
set -euo pipefail

schema="platform/state/db/schema/core.ts"
sql="platform/state/db/migrations/0001_domain_state.sql"

for table in \
  customer_identities conversations conversation_states carts cart_items \
  order_scopes commerce_orders actions authorizations execution_operations \
  transactions escalations audit_events idempotency_keys knowledge_documents
do
  grep -q "\"$table\"" "$schema" || {
    echo "Missing Drizzle table: $table"
    exit 1
  }
  grep -q "CREATE TABLE \"$table\"" "$sql" || {
    echo "Missing canonical SQL table: $table"
    exit 1
  }
done

echo "PASS: 15-table domain schema parity"
