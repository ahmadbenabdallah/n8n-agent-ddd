import { and, eq } from "drizzle-orm";
import type { NodePgDatabase } from "drizzle-orm/node-postgres";
import { customerIdentities } from "../db/schema";

export type CustomerIdentityRecord = typeof customerIdentities.$inferSelect;

export interface CustomerIdentityRepository {
  findByChannelRef(channel: string, channelIdentity: string): Promise<CustomerIdentityRecord | undefined>;
}

// Identity is unique per (channel, channel_identity); see the customer_identities
// table in platform/state/db/migrations/0001_domain_state.sql.
export function createCustomerIdentityRepository(
  db: NodePgDatabase<Record<string, never>>,
): CustomerIdentityRepository {
  return {
    async findByChannelRef(channel, channelIdentity) {
      const rows = await db
        .select()
        .from(customerIdentities)
        .where(
          and(
            eq(customerIdentities.channel, channel),
            eq(customerIdentities.channelIdentity, channelIdentity),
          ),
        )
        .limit(1);

      return rows[0];
    },
  };
}
