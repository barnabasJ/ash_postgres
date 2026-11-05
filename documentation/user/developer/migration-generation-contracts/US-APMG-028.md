# US-APMG-028 — Selected identity renames preserve forward and reverse index order

As a developer, I need identity indexes to stay valid while their columns are renamed.

Given an initial title identity and a next resource with a subject identity and another candidate attribute,

When the developer confirms the rename and selects subject,

Then both directions drop the old unique index before renaming its column and create the replacement index after the rename.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-028`.

Status: source migrated; executable verification pending.
