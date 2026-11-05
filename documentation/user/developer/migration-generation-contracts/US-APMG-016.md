# US-APMG-016 — Column renames precede replacement indexes

As a developer, I need a renamed indexed column to exist before its replacement index is created.

Given a persisted initial snapshot with a title index and an immutable next-version resource with title_short and its index,

When native generation receives confirmation that the column was renamed,

Then the forward migration renames title before creating the title_short index, and the reverse migration renames title_short before recreating the title index.

Owning case: `test/migration_generator_index_evolution_test.exs`, story tag `US-APMG-016`.

Status: source migrated; executable verification pending.
