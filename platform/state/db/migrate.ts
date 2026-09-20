import { migrate } from "drizzle-orm/node-postgres/migrator";
import { sql } from "drizzle-orm";
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { createDatabase } from "./client";

// Provider profiles hold statements that only apply to one Postgres provider
// (for example Supabase's anon/authenticated roles). The migrations themselves
// stay provider-neutral.
async function applyProfile(db: { execute: (query: ReturnType<typeof sql.raw>) => Promise<unknown> }) {
  const profile = process.env.DATABASE_PROFILE;
  if (!profile || profile === "postgres") return;

  const dir = join("platform/state/db/profiles", profile);
  if (!existsSync(dir)) {
    throw new Error(`Unknown DATABASE_PROFILE '${profile}': ${dir} does not exist`);
  }

  for (const file of readdirSync(dir)
    .filter((f) => f.endsWith(".sql"))
    .sort()) {
    await db.execute(sql.raw(readFileSync(join(dir, file), "utf8")));
    console.log(`Applied ${profile} profile: ${file}`);
  }
}

async function main() {
  if (!process.env.DATABASE_URL) {
    throw new Error("DATABASE_URL is required");
  }

  if (process.env.NODE_ENV === "production" && process.env.ALLOW_PRODUCTION_MIGRATION !== "true") {
    throw new Error(
      "Production migration blocked. Set ALLOW_PRODUCTION_MIGRATION=true only through the approved deployment gate.",
    );
  }

  const { db, pool } = createDatabase();
  try {
    await migrate(db, { migrationsFolder: "./platform/state/db/migrations" });
    console.log("Database migrations applied.");
    await applyProfile(db);
  } finally {
    await pool.end();
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
