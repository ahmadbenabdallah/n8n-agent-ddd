import {
  pgTable,
  uuid,
  text,
  timestamp,
  integer,
  bigint,
  numeric,
  jsonb,
  boolean,
  vector,
  index,
  uniqueIndex,
} from "drizzle-orm/pg-core";

export const customerIdentities = pgTable(
  "customer_identities",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    channel: text("channel").notNull(),
    channelIdentity: text("channel_identity").notNull(),
    commerceCustomerId: bigint("commerce_customer_id", { mode: "number" }),
    assuranceLevel: text("assurance_level").notNull().default("ANONYMOUS"),
    verifiedAt: timestamp("verified_at", { withTimezone: true }),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    channelIdentityUq: uniqueIndex("customer_identities_channel_identity_uq").on(
      t.channel,
      t.channelIdentity,
    ),
  }),
);

export const conversations = pgTable(
  "conversations",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    customerIdentityId: uuid("customer_identity_id").references(() => customerIdentities.id),
    channel: text("channel").notNull(),
    status: text("status").notNull().default("active"),
    language: text("language").notNull().default("tn"),
    script: text("script").notNull().default("latin"),
    register: text("register").notNull().default("casual"),
    humanOwnerId: text("human_owner_id"),
    contextVersion: bigint("context_version", { mode: "number" }).notNull().default(1),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    customerIdx: index("idx_conv_customer").on(t.customerIdentityId),
  }),
);

export const conversationStates = pgTable("conversation_states", {
  conversationId: uuid("conversation_id")
    .primaryKey()
    .references(() => conversations.id, { onDelete: "cascade" }),
  intent: text("intent"),
  activeWorkflow: text("active_workflow"),
  state: jsonb("state").notNull().default({}),
  version: bigint("version", { mode: "number" }).notNull().default(1),
  updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
});

export const carts = pgTable(
  "carts",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    customerIdentityId: uuid("customer_identity_id")
      .notNull()
      .references(() => customerIdentities.id),
    currency: text("currency").notNull().default("TND"),
    status: text("status").notNull().default("active"),
    version: bigint("version", { mode: "number" }).notNull().default(1),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    customerIdx: index("idx_cart_customer").on(t.customerIdentityId),
  }),
);

export const cartItems = pgTable(
  "cart_items",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    cartId: uuid("cart_id")
      .notNull()
      .references(() => carts.id, { onDelete: "cascade" }),
    productId: bigint("product_id", { mode: "number" }).notNull(),
    variationId: bigint("variation_id", { mode: "number" }),
    quantity: integer("quantity").notNull(),
    verifiedUnitPrice: numeric("verified_unit_price", { precision: 18, scale: 3 }),
    currency: text("currency").notNull().default("TND"),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    cartIdx: index("idx_cart_items_cart").on(t.cartId),
  }),
);

export const orderScopes = pgTable(
  "order_scopes",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    customerIdentityId: uuid("customer_identity_id")
      .notNull()
      .references(() => customerIdentities.id),
    commerceOrderId: bigint("commerce_order_id", { mode: "number" }).notNull(),
    verificationLevel: text("verification_level").notNull(),
    expiresAt: timestamp("expires_at", { withTimezone: true }),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    customerIdx: index("idx_scope_customer").on(t.customerIdentityId),
  }),
);

export const commerceOrders = pgTable(
  "commerce_orders",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    commerceOrderId: bigint("commerce_order_id", { mode: "number" }).notNull(),
    customerIdentityId: uuid("customer_identity_id").references(() => customerIdentities.id),
    status: text("status"),
    paymentStatus: text("payment_status"),
    total: numeric("total", { precision: 18, scale: 3 }),
    currency: text("currency"),
    verifiedAt: timestamp("verified_at", { withTimezone: true }),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    commerceOrderUq: uniqueIndex("commerce_orders_commerce_order_uq").on(t.commerceOrderId),
  }),
);

export const actions = pgTable("actions", {
  id: uuid("id").primaryKey().defaultRandom(),
  type: text("type").notNull(),
  target: text("target"),
  arguments: jsonb("arguments").notNull().default({}),
  source: text("source").notNull(),
  risk: text("risk").notNull().default("low"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

export const authorizations = pgTable(
  "authorizations",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    actionId: uuid("action_id")
      .notNull()
      .references(() => actions.id),
    decision: text("decision").notNull(),
    scope: jsonb("scope").notNull().default({}),
    executionAllowed: boolean("execution_allowed").notNull().default(false),
    policyVersion: text("policy_version"),
    expiresAt: timestamp("expires_at", { withTimezone: true }),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    actionIdx: index("idx_authorization_action").on(t.actionId),
  }),
);

export const executionOperations = pgTable(
  "execution_operations",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    actionId: uuid("action_id").references(() => actions.id),
    operation: text("operation").notNull(),
    idempotencyKey: text("idempotency_key").notNull(),
    requestHash: text("request_hash").notNull(),
    state: text("state").notNull().default("REQUESTED"),
    externalReference: text("external_reference"),
    result: jsonb("result"),
    failureCode: text("failure_code"),
    correlationId: text("correlation_id").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    idempotencyUq: uniqueIndex("execution_operations_idempotency_uq").on(t.idempotencyKey),
    stateIdx: index("idx_exec_state").on(t.state),
  }),
);

export const transactions = pgTable(
  "transactions",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    orderId: uuid("order_id").references(() => commerceOrders.id),
    idempotencyKey: text("idempotency_key").notNull(),
    providerReference: text("provider_reference"),
    status: text("status").notNull().default("PENDING"),
    amount: numeric("amount", { precision: 18, scale: 3 }),
    currency: text("currency"),
    verifiedAt: timestamp("verified_at", { withTimezone: true }),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    idempotencyUq: uniqueIndex("transactions_idempotency_uq").on(t.idempotencyKey),
  }),
);

export const escalations = pgTable("escalations", {
  id: uuid("id").primaryKey().defaultRandom(),
  conversationId: uuid("conversation_id")
    .notNull()
    .references(() => conversations.id),
  reason: text("reason").notNull(),
  ownerId: text("owner_id"),
  status: text("status").notNull().default("OPEN"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  resolvedAt: timestamp("resolved_at", { withTimezone: true }),
});

export const auditEvents = pgTable(
  "audit_events",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    eventType: text("event_type").notNull(),
    actorType: text("actor_type").notNull(),
    actionId: uuid("action_id").references(() => actions.id),
    correlationId: text("correlation_id").notNull(),
    causationId: text("causation_id"),
    evidence: jsonb("evidence").notNull().default({}),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    correlationIdx: index("idx_audit_correlation").on(t.correlationId),
  }),
);

export const idempotencyKeys = pgTable("idempotency_keys", {
  key: text("key").primaryKey(),
  operation: text("operation").notNull(),
  requestHash: text("request_hash").notNull(),
  status: text("status").notNull(),
  resultReference: text("result_reference"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  expiresAt: timestamp("expires_at", { withTimezone: true }),
});

export const knowledgeDocuments = pgTable(
  "knowledge_documents",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    title: text("title").notNull(),
    content: text("content").notNull(),
    source: text("source"),
    version: bigint("version", { mode: "number" }).notNull().default(1),
    status: text("status").notNull().default("draft"),
    metadata: jsonb("metadata").notNull().default({}),
    embedding: vector("embedding", { dimensions: 1536 }),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    publishedAt: timestamp("published_at", { withTimezone: true }),
  },
  (t) => ({
    statusIdx: index("idx_kb_status").on(t.status),
  }),
);

export const customerConfigurations = pgTable(
  "customer_configurations",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    domainId: text("domain_id").notNull(),
    configKey: text("config_key").notNull(),
    configValue: jsonb("config_value").notNull(),
    version: bigint("version", { mode: "number" }).notNull().default(1),
    updatedBy: text("updated_by").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({ domainKeyUq: uniqueIndex("customer_configurations_domain_key_uq").on(t.domainId, t.configKey) }),
);

export const customerExtensions = pgTable(
  "customer_extensions",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    domainId: text("domain_id").notNull(),
    extensionId: text("extension_id").notNull(),
    version: text("version").notNull(),
    lifecycle: text("lifecycle").notNull().default("DRAFT"),
    manifest: jsonb("manifest").notNull(),
    compatibility: jsonb("compatibility").notNull(),
    provenance: jsonb("provenance").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    domainExtensionUq: uniqueIndex("customer_extensions_domain_extension_uq").on(t.domainId, t.extensionId),
  }),
);

export const configurationChanges = pgTable(
  "configuration_changes",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    domainId: text("domain_id").notNull(),
    configKey: text("config_key").notNull(),
    oldValue: jsonb("old_value"),
    newValue: jsonb("new_value"),
    actorId: text("actor_id").notNull(),
    correlationId: text("correlation_id").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => ({
    domainIdx: index("idx_configuration_changes_domain").on(t.domainId),
    correlationIdx: index("idx_configuration_changes_correlation").on(t.correlationId),
  }),
);
