import { migrate } from "drizzle-orm/node-postgres/migrator";
import { createDatabase } from "./client";

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
  } finally {
    await pool.end();
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
