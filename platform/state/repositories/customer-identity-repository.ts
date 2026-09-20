import { eq, and } from "drizzle-orm";
import { customerIdentities } from "../db/schema";

export type CustomerIdentityRecord = typeof customerIdentities.$inferSelect;

export interface CustomerIdentityRepository {
  findByChannelRef(channel: string, channelIdentity: string): Promise<CustomerIdentityRecord | undefined>;
}

// Identity is unique per (channel, channel_identity); see runtime/supabase/migrations/0001.
export function createCustomerIdentityRepository(db: any): CustomerIdentityRepository {
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
