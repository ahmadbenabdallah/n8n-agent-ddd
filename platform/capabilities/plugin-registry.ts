export interface PluginManifest {
  id: string;
  version: string;
  type: string;
  capabilities: string[];
  permissions: string[];
  source?: string;
}

export class PluginRegistry {
  private readonly plugins = new Map<string, PluginManifest>();

  register(plugin: PluginManifest): void {
    if (this.plugins.has(plugin.id)) {
      throw new Error(`Plugin already registered: ${plugin.id}`);
    }
    this.plugins.set(plugin.id, plugin);
  }

  get(id: string): PluginManifest | undefined {
    return this.plugins.get(id);
  }

  list(): PluginManifest[] {
    return [...this.plugins.values()];
  }
}
