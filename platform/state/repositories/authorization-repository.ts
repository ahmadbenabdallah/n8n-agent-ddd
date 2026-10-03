/**
 * The `authorizations` table behind the authorization port's store seam.
 *
 * This is the only path by which an authorization record is written or read,
 * which is what makes `execution_allowed` a stored fact rather than a payload
 * field. Column names are the table's (0001_domain_state.sql:22-31 plus the
 * nullable correlation fields of 0006); the record's field names are the
 * ones 04-WF-10-AUTHORIZATION-RECORD.md uses, so the mapping happens here and
 * nowhere else.
 */
import { eq } from "drizzle-orm";
import type { NodePgDatabase } from "drizzle-orm/node-postgres";
import type {
  AuthorizationDecision,
  AuthorizationRecord,
  AuthorizationStore,
  NewAuthorizationRecord,
} from "../../authorization/port";
import { authorizations } from "../db/schema";

type Row = typeof authorizations.$inferSelect;

const toRecord = (row: Row): AuthorizationRecord => ({
  authorization_id: row.id,
  action_id: row.actionId,
  request_id: row.requestId,
  conversation_id: row.conversationId,
  identity_level: row.identityLevel,
  state_version: row.stateVersion,
  idempotency_key: row.idempotencyKey,
  decision: row.decision as AuthorizationDecision,
  execution_allowed: row.executionAllowed,
  policy_version: row.policyVersion,
  scope: (row.scope ?? {}) as Record<string, unknown>,
  expires_at: row.expiresAt,
  created_at: row.createdAt,
});

export function createAuthorizationRepository(db: NodePgDatabase<Record<string, never>>): AuthorizationStore {
  return {
    async insert(record: NewAuthorizationRecord) {
      // The table's own invariant, held at the write seam as well as at the
      // decision: `execution_allowed=true` is valid only with AUTHORIZED
      // (01-WF-10-AUTHORIZATION-SPEC.md:27). A caller reaching the repository
      // directly cannot store authority without the decision that grants it.
      if (record.execution_allowed && record.decision !== "AUTHORIZED")
        throw new Error("execution_allowed_requires_authorized_decision");

      const rows = await db
        .insert(authorizations)
        .values({
          actionId: record.action_id,
          decision: record.decision,
          scope: record.scope,
          executionAllowed: record.execution_allowed,
          policyVersion: record.policy_version,
          expiresAt: record.expires_at,
          requestId: record.request_id,
          conversationId: record.conversation_id,
          identityLevel: record.identity_level,
          stateVersion: record.state_version,
          idempotencyKey: record.idempotency_key,
        })
        .returning();

      return toRecord(rows[0]);
    },

    async findById(authorizationId: string) {
      const rows = await db
        .select()
        .from(authorizations)
        .where(eq(authorizations.id, authorizationId))
        .limit(1);

      return rows[0] && toRecord(rows[0]);
    },
  };
}
