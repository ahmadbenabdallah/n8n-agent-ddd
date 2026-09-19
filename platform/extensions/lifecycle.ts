import type { ExtensionLifecycle } from "./types";

const ALLOWED: Record<ExtensionLifecycle, ExtensionLifecycle[]> = {
  DRAFT: ["VALIDATED"],
  VALIDATED: ["ENABLED"],
  ENABLED: ["DISABLED", "INCOMPATIBLE"],
  DISABLED: ["ENABLED", "RETIRED"],
  INCOMPATIBLE: ["RETIRED"],
  RETIRED: [],
};

export function canTransition(from: ExtensionLifecycle, to: ExtensionLifecycle): boolean {
  return ALLOWED[from].includes(to);
}
