/**
 * Behavioural tests for the ownership and extension gates.
 *
 * These decide whether an operator may edit a workflow in n8n and whether a
 * customer extension may replace one. They previously imported a hardcoded
 * ["WF-01","WF-10","WF-15","WF-20"] and had no test at all: deleting an entry
 * changed who may edit the authorization workflow with the suite still green.
 */
import assert from "node:assert/strict";
import { isProtectedWorkflow, type CustomerExtension } from "../../../platform/extensions/types";
import { workflowOwnership } from "../../../platform/ownership/policy";
import { canCustomerEditWorkflow } from "../../../platform/customization/policy";
import { validateExtension } from "../../../platform/extensions/registry";

// A domain's own set. Deliberately not WF-NN: ids belong to the domain.
const PROTECTED = ["BOOK-AUTHZ", "BOOK-AUDIT"] as const;

// isProtectedWorkflow
assert.equal(isProtectedWorkflow("BOOK-AUTHZ", PROTECTED), true, "declared id is protected");
assert.equal(isProtectedWorkflow("BOOK-ENGINE", PROTECTED), false, "undeclared id is not protected");
assert.equal(isProtectedWorkflow("WF-10", PROTECTED), false, "another domain's id is not protected here");
assert.equal(isProtectedWorkflow("BOOK-AUTHZ", []), false, "empty set protects nothing");

// Ownership: protected workflows are platform-owned and released from git.
const authz = workflowOwnership("BOOK-AUTHZ", PROTECTED);
assert.equal(authz.protected, true);
assert.equal(authz.surface, "core");
assert.equal(authz.owner, "platform");
assert.equal(authz.sourceOfTruth, "git");
assert.equal(authz.editableByOperator, false, "operator must not edit the authorization workflow");
assert.equal(authz.editableInN8n, false);
assert.equal(authz.releaseControlled, true);

const engine = workflowOwnership("BOOK-ENGINE", PROTECTED);
assert.equal(engine.protected, false);
assert.equal(engine.surface, "extension");
assert.equal(engine.owner, "n8n");
assert.equal(engine.sourceOfTruth, "n8n");
assert.equal(engine.editableByOperator, true, "domain business workflows stay editable");

// Customer edit rights follow the same set.
assert.equal(canCustomerEditWorkflow("BOOK-AUTHZ", PROTECTED), false);
assert.equal(canCustomerEditWorkflow("BOOK-AUDIT", PROTECTED), false);
assert.equal(canCustomerEditWorkflow("BOOK-ENGINE", PROTECTED), true);

// Extensions may not own or replace a protected workflow.
const extension = (workflows: string[], permissions: string[] = []): CustomerExtension => ({
  extensionId: "acme-extra",
  version: "1.0.0",
  owner: "customer",
  type: "n8n_workflow",
  compatibility: { runtime: "1.x", domain: "booking" },
  permissions,
  workflows,
  provenance: { source: "n8n", createdBy: "operator", createdAt: "2026-09-20T00:00:00Z" },
  lifecycle: "DRAFT",
});

assert.deepEqual(validateExtension(extension(["BOOK-ENGINE"]), PROTECTED), [], "extending a domain workflow is allowed");

const replacesProtected = validateExtension(extension(["BOOK-AUTHZ"]), PROTECTED);
assert.ok(
  replacesProtected.some((e) => e.includes("protected workflow")),
  "extension replacing a protected workflow must be rejected",
);

const forbiddenPermission = validateExtension(extension(["BOOK-ENGINE"], ["commerce.authorization"]), PROTECTED);
assert.ok(
  forbiddenPermission.some((e) => e.includes("forbidden permission")),
  "extension requesting commerce.authorization must be rejected",
);

const platformOwned = validateExtension({ ...extension(["BOOK-ENGINE"]), owner: "platform" }, PROTECTED);
assert.ok(platformOwned.length > 0, "platform-owned extension does not belong in the customer registry");

console.log("PASS: executable ownership and extension gates");
