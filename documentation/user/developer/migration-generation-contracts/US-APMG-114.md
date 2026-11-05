# US-APMG-114 — Combine explicit matching with tenant matching

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a tenant-scoped user reference targets secondary_id and specifies additional related-key matching,

When the native generator writes its migration,

Then the foreign key includes both the authored matching pair and org_id tenant matching with the selected full match type.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-114`.

Status: source extracted from the existing reference case; executable verification pending.
