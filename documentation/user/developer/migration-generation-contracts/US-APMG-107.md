# US-APMG-107 — Change a reference index predicate without replacing its foreign key

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given an initial reference index has no predicate and an immutable next version adds post_id IS NOT NULL,

When native generation compares the next version with the initial snapshot,

Then the follow-up drops the old index and creates the partial index without dropping or modifying the foreign key.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-107`.

Status: source extracted from the existing reference case; executable verification pending.
