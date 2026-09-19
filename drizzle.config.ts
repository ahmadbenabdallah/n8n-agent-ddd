import { defineConfig } from "drizzle-kit";

export default defineConfig({
  schema: "./platform/state/db/schema/index.ts",
  out: "./platform/state/db/migrations",
  dialect: "postgresql",
  dbCredentials: {
    url: process.env.DATABASE_URL ?? "",
  },
  strict: true,
  verbose: true,
});
