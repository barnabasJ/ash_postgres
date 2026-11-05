# US-APMG-108 — Disable a reference index without replacing its foreign key

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given an initial reference enables index? and an immutable next version disables it,

When native generation compares the next version with the initial snapshot,

Then the follow-up drops the reference index without dropping its constraint, modifying its reference, or modifying its attribute.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-108`.

Status: source extracted from the existing reference case; executable verification pending.
