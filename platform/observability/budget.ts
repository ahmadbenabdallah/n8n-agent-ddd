export type BudgetStatus = "ok" | "warning" | "exceeded";

export interface BudgetPolicy {
  dailyUsd: number;
  warningRatio: number;
  hardStopRatio: number;
}

export interface BudgetEvaluation {
  spentUsd: number;
  budgetUsd: number;
  ratio: number;
  status: BudgetStatus;
}

export function evaluateBudget(spentUsd: number, policy: BudgetPolicy): BudgetEvaluation {
  if (policy.dailyUsd <= 0) throw new Error("dailyUsd must be greater than zero");
  if (!(policy.warningRatio > 0 && policy.warningRatio < policy.hardStopRatio)) {
    throw new Error("warningRatio must be positive and below hardStopRatio");
  }
  if (spentUsd < 0) throw new Error("spentUsd cannot be negative");
  const ratio = spentUsd / policy.dailyUsd;
  const status: BudgetStatus = ratio >= policy.hardStopRatio ? "exceeded" : ratio >= policy.warningRatio ? "warning" : "ok";
  return { spentUsd, budgetUsd: policy.dailyUsd, ratio, status };
}
