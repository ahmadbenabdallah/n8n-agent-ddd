CREATE TABLE IF NOT EXISTS customer_configurations (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 domain_id text NOT NULL,
 config_key text NOT NULL,
 config_value jsonb NOT NULL,
 version bigint NOT NULL DEFAULT 1,
 updated_by text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(domain_id, config_key)
);

CREATE INDEX IF NOT EXISTS idx_customer_config_domain ON customer_configurations(domain_id);

CREATE TABLE IF NOT EXISTS customer_extensions (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 domain_id text NOT NULL,
 extension_id text NOT NULL,
 version text NOT NULL,
 lifecycle text NOT NULL DEFAULT 'DRAFT',
 manifest jsonb NOT NULL,
 compatibility jsonb NOT NULL,
 provenance jsonb NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(domain_id, extension_id)
);

CREATE INDEX IF NOT EXISTS idx_customer_extensions_domain ON customer_extensions(domain_id);
CREATE INDEX IF NOT EXISTS idx_customer_extensions_lifecycle ON customer_extensions(lifecycle);

CREATE TABLE IF NOT EXISTS configuration_changes (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 domain_id text NOT NULL,
 config_key text NOT NULL,
 old_value jsonb,
 new_value jsonb,
 actor_id text NOT NULL,
 correlation_id text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_configuration_changes_domain ON configuration_changes(domain_id);
CREATE INDEX IF NOT EXISTS idx_configuration_changes_correlation ON configuration_changes(correlation_id);
