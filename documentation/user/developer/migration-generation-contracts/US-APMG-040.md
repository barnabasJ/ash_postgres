# US-APMG-040 — Schema-qualified renames preserve additional field changes

As a developer, I need schema and tenant identity to survive reversible resource changes.

Given an actual example.posts title snapshot and an immutable next resource with required name and default fred,

When native generation receives confirmation of the rename,

Then forward SQL renames before applying null false and default fred, and reverse SQL restores nullability/default before renaming name back to title.

Owning case: `test/migration_generator_schema_renames_test.exs`, story tag `US-APMG-040`.

Status: source migrated; executable verification pending.
