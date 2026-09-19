import { eq, and } from "drizzle-orm";
import { customerIdentity } from "../db/schema";

export interface CustomerIdentityRecord {
  id: string;
  domainId: string;
  channel: string;
  channelUserRef: string;
  assuranceLevel: string;
}

export interface CustomerIdentityRepository {
  findByChannelRef(
    domainId: string,
    channel: string,
    channelUserRef: string,
  ): Promise<CustomerIdentityRecord | undefined>;
}

export function createCustomerIdentityRepository(db: any): CustomerIdentityRepository {
  return {
    async findByChannelRef(domainId, channel, channelUserRef) {
      const rows = await db
        .select()
        .from(customerIdentity)
        .where(
          and(
            eq(customerIdentity.domainId, domainId),
            eq(customerIdentity.channel, channel),
            eq(customerIdentity.channelUserRef, channelUserRef),
          ),
        )
        .limit(1);

      return rows[0];
    },
  };
}
