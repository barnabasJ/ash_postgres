# US-APMG-119 — Replace a filtered identity when its name and predicate change together

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given an all-tenant name identity changes both its base filter and its configured index name,

When native generation compares the two immutable versions,

Then the follow-up drops the original index and creates the newly named filtered index without emitting ALTER INDEX.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-119`.

Status: source extracted from the existing reference case; executable verification pending.
