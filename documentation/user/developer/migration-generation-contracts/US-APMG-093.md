# US-APMG-093 — Decline a rename and confirm the original table drop

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given one old table has two new table candidates in the next immutable domain,

When native generation receives a declined rename answer followed by a confirmed drop answer,

Then the migration drops the old table and creates both new tables without renaming the original table.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-093`.

Status: source extracted from the existing table-rename case; executable verification pending.
