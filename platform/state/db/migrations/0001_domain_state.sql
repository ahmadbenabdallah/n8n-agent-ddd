CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS customer_identities (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 channel text NOT NULL,
 channel_identity text NOT NULL,
 commerce_customer_id bigint,
 assurance_level text NOT NULL DEFAULT 'ANONYMOUS',
 verified_at timestamptz,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(channel, channel_identity)
);

CREATE TABLE IF NOT EXISTS conversations (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 customer_identity_id uuid REFERENCES customer_identities(id),
 channel text NOT NULL,
 status text NOT NULL DEFAULT 'active',
 language text NOT NULL DEFAULT 'tn',
 script text NOT NULL DEFAULT 'latin',
 register text NOT NULL DEFAULT 'casual',
 human_owner_id text,
 context_version bigint NOT NULL DEFAULT 1,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS conversation_states (
 conversation_id uuid PRIMARY KEY REFERENCES conversations(id) ON DELETE CASCADE,
 intent text,
 active_workflow text,
 state jsonb NOT NULL DEFAULT '{}'::jsonb,
 version bigint NOT NULL DEFAULT 1,
 updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS carts (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 customer_identity_id uuid NOT NULL REFERENCES customer_identities(id),
 currency text NOT NULL DEFAULT 'TND',
 status text NOT NULL DEFAULT 'active',
 version bigint NOT NULL DEFAULT 1,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cart_items (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 cart_id uuid NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
 product_id bigint NOT NULL,
 variation_id bigint,
 quantity integer NOT NULL CHECK(quantity > 0),
 verified_unit_price numeric(18,3),
 currency text NOT NULL DEFAULT 'TND',
 updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS order_scopes (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 customer_identity_id uuid NOT NULL REFERENCES customer_identities(id),
 commerce_order_id bigint NOT NULL,
 verification_level text NOT NULL,
 expires_at timestamptz,
 created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS commerce_orders (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 commerce_order_id bigint NOT NULL UNIQUE,
 customer_identity_id uuid REFERENCES customer_identities(id),
 status text,
 payment_status text,
 total numeric(18,3),
 currency text,
 verified_at timestamptz,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS actions (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 type text NOT NULL,
 target text,
 arguments jsonb NOT NULL DEFAULT '{}'::jsonb,
 source text NOT NULL,
 risk text NOT NULL DEFAULT 'low',
 created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS authorizations (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 action_id uuid NOT NULL REFERENCES actions(id),
 decision text NOT NULL,
 scope jsonb NOT NULL DEFAULT '{}'::jsonb,
 execution_allowed boolean NOT NULL DEFAULT false,
 policy_version text,
 expires_at timestamptz,
 created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS execution_operations (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 action_id uuid REFERENCES actions(id),
 operation text NOT NULL,
 idempotency_key text NOT NULL UNIQUE,
 request_hash text NOT NULL,
 state text NOT NULL DEFAULT 'REQUESTED',
 external_reference text,
 result jsonb,
 failure_code text,
 correlation_id text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS transactions (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 order_id uuid REFERENCES commerce_orders(id),
 idempotency_key text NOT NULL UNIQUE,
 provider_reference text,
 status text NOT NULL DEFAULT 'PENDING',
 amount numeric(18,3),
 currency text,
 verified_at timestamptz,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS escalations (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 conversation_id uuid NOT NULL REFERENCES conversations(id),
 reason text NOT NULL,
 owner_id text,
 status text NOT NULL DEFAULT 'OPEN',
 created_at timestamptz NOT NULL DEFAULT now(),
 resolved_at timestamptz
);

CREATE TABLE IF NOT EXISTS audit_events (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 event_type text NOT NULL,
 actor_type text NOT NULL,
 action_id uuid REFERENCES actions(id),
 correlation_id text NOT NULL,
 causation_id text,
 evidence jsonb NOT NULL DEFAULT '{}'::jsonb,
 created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS idempotency_keys (
 key text PRIMARY KEY,
 operation text NOT NULL,
 request_hash text NOT NULL,
 status text NOT NULL,
 result_reference text,
 created_at timestamptz NOT NULL DEFAULT now(),
 expires_at timestamptz
);

CREATE TABLE IF NOT EXISTS knowledge_documents (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 title text NOT NULL,
 content text NOT NULL,
 source text,
 version bigint NOT NULL DEFAULT 1,
 status text NOT NULL DEFAULT 'draft',
 metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
 embedding vector(1536),
 created_at timestamptz NOT NULL DEFAULT now(),
 published_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_conv_customer ON conversations(customer_identity_id);
CREATE INDEX IF NOT EXISTS idx_cart_customer ON carts(customer_identity_id);
CREATE INDEX IF NOT EXISTS idx_scope_customer ON order_scopes(customer_identity_id);
CREATE INDEX IF NOT EXISTS idx_audit_correlation ON audit_events(correlation_id);
CREATE INDEX IF NOT EXISTS idx_exec_state ON execution_operations(state);
CREATE INDEX IF NOT EXISTS idx_kb_status ON knowledge_documents(status);
CREATE INDEX IF NOT EXISTS knowledge_documents_embedding_hnsw_idx
ON knowledge_documents USING hnsw (embedding vector_cosine_ops);
