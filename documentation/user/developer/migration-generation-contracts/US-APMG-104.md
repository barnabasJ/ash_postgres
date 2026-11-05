# US-APMG-104 — Preserve explicit reference matching

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a belongs-to reference specifies related_key_id to key_id matching and partial match type,

When the native generator writes its migration,

Then the foreign key retains the explicit matching columns and partial match type.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-104`.

Status: source extracted from the existing reference case; executable verification pending.
