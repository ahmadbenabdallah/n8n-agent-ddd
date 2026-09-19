export type RuntimeConfigClass =
  | "public_runtime"
  | "secret"
  | "application"
  | "provider";

export interface RuntimeConfigEntry {
  key: string;
  class: RuntimeConfigClass;
  source: "environment" | "secret_provider" | "postgres";
  required: boolean;
  mutable: boolean;
}

export const runtimeConfigContract: RuntimeConfigEntry[] = [
  { key: "N8N_BASE_URL", class: "public_runtime", source: "environment", required: true, mutable: false },
  { key: "N8N_ENCRYPTION_KEY", class: "secret", source: "secret_provider", required: true, mutable: false },
  { key: "DB_POSTGRESDB_PASSWORD", class: "secret", source: "secret_provider", required: true, mutable: false },
  { key: "DATABASE_PROFILE", class: "provider", source: "environment", required: true, mutable: false },
];
