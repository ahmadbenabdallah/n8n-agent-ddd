-- Correlation and binding fields of the WF-10 authorization record
-- (domains/tunisia-dtc/workflow-packages/WF-10/04-WF-10-AUTHORIZATION-RECORD.md).
-- Expand-only and nullable: no rows exist, nothing is backfilled, and no
-- down-migration. The authority column itself, execution_allowed, already
-- exists in 0001 with DEFAULT false NOT NULL.
ALTER TABLE "authorizations" ADD COLUMN "request_id" text;--> statement-breakpoint
ALTER TABLE "authorizations" ADD COLUMN "conversation_id" text;--> statement-breakpoint
ALTER TABLE "authorizations" ADD COLUMN "identity_level" text;--> statement-breakpoint
ALTER TABLE "authorizations" ADD COLUMN "state_version" integer;--> statement-breakpoint
ALTER TABLE "authorizations" ADD COLUMN "idempotency_key" text;
