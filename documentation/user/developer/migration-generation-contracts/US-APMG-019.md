# US-APMG-019 — Identity and column renames remain reversible

As a developer, I need an identity's index to follow the renamed column in both migration directions.

Given an initial title identity and an immutable next resource whose identity targets title_short,

When native generation receives confirmation of the column rename,

Then the forward migration renames title before creating the new unique index. The reverse migration restores title before creating the original unique index.

Owning case: `test/migration_generator_identity_rename_test.exs`, story tag `US-APMG-019`.

Status: source migrated; executable verification pending.
