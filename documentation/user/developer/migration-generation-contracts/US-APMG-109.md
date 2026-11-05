# US-APMG-109 — Keep the schema in deferrable constraint changes

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given posts and its reference use the example schema, and the reference changes from initially deferred to deferrable,

When native generation compares the two immutable versions,

Then the follow-up ALTER TABLE operation names example.posts.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-109`.

Status: source extracted from the existing reference case; executable verification pending.
