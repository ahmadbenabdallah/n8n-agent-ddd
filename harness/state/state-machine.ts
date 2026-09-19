export const lifecycleStates = [
  "DISCOVER", "DEFINE", "DOMAIN", "SPECIFY", "ARCHITECT", "DESIGN", "DECOMPOSE",
  "PLAN", "IMPLEMENT", "TEST", "SECURITY", "REVIEW", "INTEGRATE", "DEPLOY",
  "VERIFY", "OPERATE", "LEARN"
] as const;

export type LifecycleState = typeof lifecycleStates[number];

const transitions: Record<LifecycleState, LifecycleState[]> = {
  DISCOVER: ["DEFINE"],
  DEFINE: ["DOMAIN", "DISCOVER"],
  DOMAIN: ["SPECIFY", "DEFINE"],
  SPECIFY: ["ARCHITECT", "DOMAIN"],
  ARCHITECT: ["DESIGN", "SPECIFY"],
  DESIGN: ["DECOMPOSE", "ARCHITECT"],
  DECOMPOSE: ["PLAN", "DESIGN"],
  PLAN: ["IMPLEMENT", "DECOMPOSE"],
  IMPLEMENT: ["TEST", "PLAN"],
  TEST: ["SECURITY", "IMPLEMENT"],
  SECURITY: ["REVIEW", "IMPLEMENT"],
  REVIEW: ["INTEGRATE", "IMPLEMENT"],
  INTEGRATE: ["DEPLOY", "REVIEW"],
  DEPLOY: ["VERIFY", "INTEGRATE"],
  VERIFY: ["OPERATE", "DEPLOY"],
  OPERATE: ["LEARN", "VERIFY"],
  LEARN: ["DEFINE", "OPERATE"]
};

export function canTransition(from: LifecycleState, to: LifecycleState): boolean {
  return transitions[from].includes(to);
}
