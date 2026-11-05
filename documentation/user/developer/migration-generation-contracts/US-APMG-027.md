# US-APMG-027 — A selected rename target determines the generated column rename

As a developer, I need my selected rename target to be used in both migration directions.

Given an initial title and a next resource with multiple candidate attributes,

When the developer confirms a rename and selects subject through native prompt input,

Then the migration renames title to subject.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-027`.

Status: source migrated; executable verification pending.
