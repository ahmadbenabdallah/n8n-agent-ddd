export interface LlmUsage {
  inputTokens: number;
  outputTokens: number;
  estimatedCost: number;
  model: string;
  promptVersion: string;
}

export function aggregateCost(records: LlmUsage[]) {
  return records.reduce(
    (a, r) => ({
      inputTokens: a.inputTokens + r.inputTokens,
      outputTokens: a.outputTokens + r.outputTokens,
      estimatedCost: a.estimatedCost + r.estimatedCost,
    }),
    { inputTokens: 0, outputTokens: 0, estimatedCost: 0 },
  );
}
