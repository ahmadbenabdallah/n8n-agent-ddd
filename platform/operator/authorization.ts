import type { OperatorIdentity } from "./types";

const CONFIG_ROLES = new Set(["owner", "admin", "operator"]);
const EXTENSION_ROLES = new Set(["owner", "admin", "editor"]);

export function canEditConfiguration(identity: OperatorIdentity): boolean {
  return CONFIG_ROLES.has(identity.role);
}

export function canEditExtension(identity: OperatorIdentity): boolean {
  return EXTENSION_ROLES.has(identity.role);
}

export function canChangeInfrastructure(identity: OperatorIdentity): boolean {
  return false;
}
