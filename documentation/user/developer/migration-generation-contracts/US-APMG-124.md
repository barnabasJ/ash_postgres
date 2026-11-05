# US-APMG-124 — Respect an explicit tenant reference match type

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a nullable tenant-scoped user reference enables match_tenant? and explicitly selects full match type,

When the native generator writes its migration,

Then the foreign key retains full match type instead of inferring simple matching.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-124`.

Status: source extracted from the existing reference case; executable verification pending.
