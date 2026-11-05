# US-APMG-121 — Match tenant columns only where required

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given two tenant-scoped user references target respectively secondary_id and the primary id,

When the native generator writes their migration,

Then the secondary-id reference includes tenant matching while the primary-id reference keeps the ordinary inferred foreign key.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-121`.

Status: source extracted from the existing reference case; executable verification pending.
