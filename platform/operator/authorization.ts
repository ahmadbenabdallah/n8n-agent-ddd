import type { OperatorIdentity } from "./types";

const CONFIG_ROLES = new Set(["owner", "admin", "operator"]);
const EXTENSION_ROLES = new Set(["owner", "admin", "editor"]);

export function canEditConfiguration(identity: OperatorIdentity): boolean {
  return CONFIG_ROLES.has(identity.role);
}

export function canEditExtension(identity: OperatorIdentity): boolean {
  return EXTENSION_ROLES.has(identity.role);
}

/**
 * Infrastructure is never operator-changeable, whoever is asking. The
 * parameter is kept so this reads like its siblings and so the answer can
 * become role-dependent later without changing every call site.
 */
export function canChangeInfrastructure(_identity: OperatorIdentity): boolean {
  return false;
}
