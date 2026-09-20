import type { ConfigDecision, ConfigurationClass } from "./types";

const FORBIDDEN = new Set([
  "DATABASE_URL",
  "N8N_ENCRYPTION_KEY",
  "N8N_USER_MANAGEMENT_JWT_SECRET",
  "OPENAI_API_KEY",
  "WOO_COMMERCE_CONSUMER_SECRET",
  "WOO_COMMERCE_CONSUMER_KEY",
  "payment_status",
  "execution_allowed",
  "authorization_decision",
  "verified_unit_price",
  "stock_quantity",
]);

const BUSINESS_KEYS = new Set([
  "business.name",
  "business.currency",
  "business.timezone",
  "business.cod_enabled",
  "business.support_hours",
  "business.max_discount_percent",
  "features.sales_enabled",
  "features.support_enabled",
  "features.human_handoff_enabled",
  "language.default",
]);

export function classifyConfigurationKey(key: string): ConfigurationClass | null {
  if (FORBIDDEN.has(key)) return null;
  if (BUSINESS_KEYS.has(key)) return "business";
  if (key.startsWith("secret.")) return "secret";
  if (key.startsWith("extension.")) return "workflow_extension";
  if (key.startsWith("platform.")) return "platform_core";
  if (key.startsWith("infra.") || key.endsWith("_URL") || key.endsWith("_KEY")) return "infrastructure";
  return null;
}

export function validateConfigChange(key: string): ConfigDecision {
  if (FORBIDDEN.has(key)) {
    return { allowed: false, reason: "Protected key cannot be customer-configured.", classification: null };
  }
  const classification = classifyConfigurationKey(key);
  if (!classification) {
    return {
      allowed: false,
      reason: "Unknown configuration key; schema declaration required.",
      classification: null,
    };
  }
  if (classification === "infrastructure" || classification === "platform_core") {
    return { allowed: false, reason: `${classification} configuration is platform-owned.`, classification };
  }
  return { allowed: true, reason: "Schema-declared customer configuration.", classification };
}
