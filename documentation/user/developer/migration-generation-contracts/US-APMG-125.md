# US-APMG-125 — Recreate a tenant foreign key when it becomes nullable

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a required tenant-matching user reference becomes nullable in the next immutable version,

When native generation compares the two versions,

Then the follow-up drops the old foreign key and recreates it with simple tenant matching and null: true.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-125`.

Status: source extracted from the existing reference case; executable verification pending.
