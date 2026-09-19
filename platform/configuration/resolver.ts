import { validateConfigChange } from "./validation";
import type { ConfigChange, CustomerRuntimeConfig } from "./types";

export function resolveConfig(config: CustomerRuntimeConfig, key: string): unknown {
  return config.values[key];
}

export function applyConfigChange(config: CustomerRuntimeConfig, change: ConfigChange): CustomerRuntimeConfig {
  const decision = validateConfigChange(change.key);
  if (!decision.allowed) throw new Error(decision.reason);
  if (change.expectedVersion !== config.version) throw new Error("CONFIG_VERSION_CONFLICT");
  return {
    ...config,
    version: config.version + 1,
    values: { ...config.values, [change.key]: change.value },
    updatedBy: change.actorId,
    updatedAt: new Date().toISOString(),
  };
}
