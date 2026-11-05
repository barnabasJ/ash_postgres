# US-APMG-105 — Index an inferred reference

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a belongs-to reference enables index?,

When the native generator writes its migration,

Then the generated SQL creates an index on the reference source column.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-105`.

Status: source extracted from the existing reference case; executable verification pending.
