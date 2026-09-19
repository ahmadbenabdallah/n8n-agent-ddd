import { createDatabase } from "./client";
import { sql } from "drizzle-orm";

async function main() {
  const { db, pool } = createDatabase();

  try {
    const result = await db.execute(sql`select current_database() as database`);
    console.log("Database validation:", result.rows);
  } finally {
    await pool.end();
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
