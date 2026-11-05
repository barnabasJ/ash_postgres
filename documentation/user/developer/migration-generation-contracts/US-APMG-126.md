# US-APMG-126 — Nilify selected reference columns under multitenancy

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given tenant-scoped items reference groups with tenant matching and on_delete: {:nilify, [:group_id]},

When the native generator writes their migration,

Then the group foreign key retains tenant matching and nilifies only group_id.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-126`.

Status: source extracted from the existing reference case; executable verification pending.
