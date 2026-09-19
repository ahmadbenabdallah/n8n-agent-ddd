CREATE TABLE "actions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"type" text NOT NULL,
	"target" text,
	"arguments" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"source" text NOT NULL,
	"risk" text DEFAULT 'low' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "audit_events" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"event_type" text NOT NULL,
	"actor_type" text NOT NULL,
	"action_id" uuid,
	"correlation_id" text NOT NULL,
	"causation_id" text,
	"evidence" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "authorizations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"action_id" uuid NOT NULL,
	"decision" text NOT NULL,
	"scope" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"execution_allowed" boolean DEFAULT false NOT NULL,
	"policy_version" text,
	"expires_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "cart_items" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"cart_id" uuid NOT NULL,
	"product_id" bigint NOT NULL,
	"variation_id" bigint,
	"quantity" integer NOT NULL,
	"verified_unit_price" numeric(18, 3),
	"currency" text DEFAULT 'TND' NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "carts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"customer_identity_id" uuid NOT NULL,
	"currency" text DEFAULT 'TND' NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"version" bigint DEFAULT 1 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "commerce_orders" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"commerce_order_id" bigint NOT NULL,
	"customer_identity_id" uuid,
	"status" text,
	"payment_status" text,
	"total" numeric(18, 3),
	"currency" text,
	"verified_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "configuration_changes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"domain_id" text NOT NULL,
	"config_key" text NOT NULL,
	"old_value" jsonb,
	"new_value" jsonb,
	"actor_id" text NOT NULL,
	"correlation_id" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "conversation_states" (
	"conversation_id" uuid PRIMARY KEY NOT NULL,
	"intent" text,
	"active_workflow" text,
	"state" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"version" bigint DEFAULT 1 NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "conversations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"customer_identity_id" uuid,
	"channel" text NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"language" text DEFAULT 'tn' NOT NULL,
	"script" text DEFAULT 'latin' NOT NULL,
	"register" text DEFAULT 'casual' NOT NULL,
	"human_owner_id" text,
	"context_version" bigint DEFAULT 1 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "customer_configurations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"domain_id" text NOT NULL,
	"config_key" text NOT NULL,
	"config_value" jsonb NOT NULL,
	"version" bigint DEFAULT 1 NOT NULL,
	"updated_by" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "customer_extensions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"domain_id" text NOT NULL,
	"extension_id" text NOT NULL,
	"version" text NOT NULL,
	"lifecycle" text DEFAULT 'DRAFT' NOT NULL,
	"manifest" jsonb NOT NULL,
	"compatibility" jsonb NOT NULL,
	"provenance" jsonb NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "customer_identities" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"channel" text NOT NULL,
	"channel_identity" text NOT NULL,
	"commerce_customer_id" bigint,
	"assurance_level" text DEFAULT 'ANONYMOUS' NOT NULL,
	"verified_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "escalations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"conversation_id" uuid NOT NULL,
	"reason" text NOT NULL,
	"owner_id" text,
	"status" text DEFAULT 'OPEN' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"resolved_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "execution_operations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"action_id" uuid,
	"operation" text NOT NULL,
	"idempotency_key" text NOT NULL,
	"request_hash" text NOT NULL,
	"state" text DEFAULT 'REQUESTED' NOT NULL,
	"external_reference" text,
	"result" jsonb,
	"failure_code" text,
	"correlation_id" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "idempotency_keys" (
	"key" text PRIMARY KEY NOT NULL,
	"operation" text NOT NULL,
	"request_hash" text NOT NULL,
	"status" text NOT NULL,
	"result_reference" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"expires_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "knowledge_documents" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"title" text NOT NULL,
	"content" text NOT NULL,
	"source" text,
	"version" bigint DEFAULT 1 NOT NULL,
	"status" text DEFAULT 'draft' NOT NULL,
	"metadata" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"embedding" vector(1536),
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"published_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "order_scopes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"customer_identity_id" uuid NOT NULL,
	"commerce_order_id" bigint NOT NULL,
	"verification_level" text NOT NULL,
	"expires_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "transactions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"order_id" uuid,
	"idempotency_key" text NOT NULL,
	"provider_reference" text,
	"status" text DEFAULT 'PENDING' NOT NULL,
	"amount" numeric(18, 3),
	"currency" text,
	"verified_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "audit_events" ADD CONSTRAINT "audit_events_action_id_actions_id_fk" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "authorizations" ADD CONSTRAINT "authorizations_action_id_actions_id_fk" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cart_items" ADD CONSTRAINT "cart_items_cart_id_carts_id_fk" FOREIGN KEY ("cart_id") REFERENCES "public"."carts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "carts" ADD CONSTRAINT "carts_customer_identity_id_customer_identities_id_fk" FOREIGN KEY ("customer_identity_id") REFERENCES "public"."customer_identities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commerce_orders" ADD CONSTRAINT "commerce_orders_customer_identity_id_customer_identities_id_fk" FOREIGN KEY ("customer_identity_id") REFERENCES "public"."customer_identities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "conversation_states" ADD CONSTRAINT "conversation_states_conversation_id_conversations_id_fk" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_customer_identity_id_customer_identities_id_fk" FOREIGN KEY ("customer_identity_id") REFERENCES "public"."customer_identities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "escalations" ADD CONSTRAINT "escalations_conversation_id_conversations_id_fk" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "execution_operations" ADD CONSTRAINT "execution_operations_action_id_actions_id_fk" FOREIGN KEY ("action_id") REFERENCES "public"."actions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_scopes" ADD CONSTRAINT "order_scopes_customer_identity_id_customer_identities_id_fk" FOREIGN KEY ("customer_identity_id") REFERENCES "public"."customer_identities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_order_id_commerce_orders_id_fk" FOREIGN KEY ("order_id") REFERENCES "public"."commerce_orders"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "idx_audit_correlation" ON "audit_events" USING btree ("correlation_id");--> statement-breakpoint
CREATE INDEX "idx_authorization_action" ON "authorizations" USING btree ("action_id");--> statement-breakpoint
CREATE INDEX "idx_cart_items_cart" ON "cart_items" USING btree ("cart_id");--> statement-breakpoint
CREATE INDEX "idx_cart_customer" ON "carts" USING btree ("customer_identity_id");--> statement-breakpoint
CREATE UNIQUE INDEX "commerce_orders_commerce_order_uq" ON "commerce_orders" USING btree ("commerce_order_id");--> statement-breakpoint
CREATE INDEX "idx_configuration_changes_domain" ON "configuration_changes" USING btree ("domain_id");--> statement-breakpoint
CREATE INDEX "idx_configuration_changes_correlation" ON "configuration_changes" USING btree ("correlation_id");--> statement-breakpoint
CREATE INDEX "idx_conv_customer" ON "conversations" USING btree ("customer_identity_id");--> statement-breakpoint
CREATE UNIQUE INDEX "customer_configurations_domain_key_uq" ON "customer_configurations" USING btree ("domain_id","config_key");--> statement-breakpoint
CREATE UNIQUE INDEX "customer_extensions_domain_extension_uq" ON "customer_extensions" USING btree ("domain_id","extension_id");--> statement-breakpoint
CREATE UNIQUE INDEX "customer_identities_channel_identity_uq" ON "customer_identities" USING btree ("channel","channel_identity");--> statement-breakpoint
CREATE UNIQUE INDEX "execution_operations_idempotency_uq" ON "execution_operations" USING btree ("idempotency_key");--> statement-breakpoint
CREATE INDEX "idx_exec_state" ON "execution_operations" USING btree ("state");--> statement-breakpoint
CREATE INDEX "idx_kb_status" ON "knowledge_documents" USING btree ("status");--> statement-breakpoint
CREATE INDEX "idx_scope_customer" ON "order_scopes" USING btree ("customer_identity_id");--> statement-breakpoint
CREATE UNIQUE INDEX "transactions_idempotency_uq" ON "transactions" USING btree ("idempotency_key");