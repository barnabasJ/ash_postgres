# US-APMG-106 — Generate a partial reference index

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a comment reference enables index? with index_where: :not_nil,

When the native generator writes the migration and snapshot,

Then the SQL index excludes null post_id values and the persisted snapshot retains that predicate.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-106`.

Status: source extracted from the existing reference case; executable verification pending.
