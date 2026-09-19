export interface SkillCandidate {
  id: string;
  capabilities: string[];
  prerequisites?: string[];
  sensitive?: boolean;
}

export interface SkillRoute {
  selected: string[];
  requiredPolicies: string[];
}

export function routeSkills(
  taskCapabilities: string[],
  candidates: SkillCandidate[],
  sensitive = false,
): SkillRoute {
  const selected = candidates
    .filter((candidate) =>
      candidate.capabilities.some((capability) => taskCapabilities.includes(capability)),
    )
    .map((candidate) => candidate.id);

  return {
    selected,
    requiredPolicies: sensitive ? ["security:agent-security"] : [],
  };
}
