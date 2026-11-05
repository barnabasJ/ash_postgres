# US-APMG-116 — Rebuild all-tenant identities when their base filter changes

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given an all-tenant name identity initially filters archived users and the next immutable version also filters hidden users,

When native generation compares the two versions,

Then the follow-up drops the old unique index and creates its replacement with the updated base-filter predicate.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-116`.

Status: source extracted from the existing reference case; executable verification pending.
