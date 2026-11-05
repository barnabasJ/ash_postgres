# US-APMG-118 — Preserve all-tenant indexes across tenant-attribute changes

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given users has a scoped name identity and all-tenant email indexes, and its tenant attribute changes from org_id to account_id,

When native generation compares the two immutable versions,

Then the follow-up drops the old scoped-name index and does not rewrite either global email index.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-118`.

Status: source extracted from the existing reference case; executable verification pending.
