export type TaskNode = {
  id: string;
  dependencies: string[];
};

export function readyTasks(tasks: TaskNode[], completed: Set<string>): TaskNode[] {
  return tasks.filter(
    (task) => !completed.has(task.id) && task.dependencies.every((dep) => completed.has(dep)),
  );
}

export function assertAcyclic(tasks: TaskNode[]): void {
  const byId = new Map(tasks.map((t) => [t.id, t]));
  const visiting = new Set<string>();
  const visited = new Set<string>();

  function visit(id: string) {
    if (visiting.has(id)) throw new Error(`Task dependency cycle detected at ${id}`);
    if (visited.has(id)) return;
    const task = byId.get(id);
    if (!task) throw new Error(`Unknown task dependency: ${id}`);
    visiting.add(id);
    for (const dep of task.dependencies) visit(dep);
    visiting.delete(id);
    visited.add(id);
  }

  for (const task of tasks) visit(task.id);
}
