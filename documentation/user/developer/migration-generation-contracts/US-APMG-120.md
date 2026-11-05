# US-APMG-120 — Drop a foreign key before changing its reference options

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given an inferred posts foreign key changes its name and delete/update behavior,

When native generation compares the two immutable versions,

Then the follow-up drops the original constraint and creates the selected reference options, and reverse SQL drops the new constraint before restoring the prior reference.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-120`.

Status: source extracted from the existing reference case; executable verification pending.
