# US-APMG-039 — Schema-qualified field renames preserve their schema

As a developer, I need schema and tenant identity to survive reversible resource changes.

Given an actual example.posts snapshot with title and an immutable next resource containing name,

When native generation receives confirmation of the column rename,

Then the actual follow-up SQL renames title to name on the example-prefixed posts table.

Owning case: `test/migration_generator_schema_renames_test.exs`, story tag `US-APMG-039`.

Status: source migrated; executable verification pending.
