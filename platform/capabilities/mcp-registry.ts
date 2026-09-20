export interface McpServerManifest {
  id: string;
  permissions: string[];
  forbidden: string[];
}

export function canUseMcpCapability(server: McpServerManifest, permission: string): boolean {
  if (server.forbidden.includes(permission)) return false;
  return server.permissions.includes(permission);
}
