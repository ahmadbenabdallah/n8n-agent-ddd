export type Readiness = {
  requirements_explicit: boolean;
  acceptance_criteria_defined: boolean;
  domain_impact_identified: boolean;
  contracts_identified: boolean;
  security_impact_assessed: boolean;
  test_strategy_defined: boolean;
  migration_impact_known: boolean;
  rollback_strategy_defined: boolean;
};

export function isDefinitionOfReady(input: Readiness): boolean {
  return Object.values(input).every(Boolean);
}
