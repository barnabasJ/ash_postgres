# US-APMG-092 — Select a rename target among multiple new tables

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given one old table has two new table candidates in the next immutable domain,

When native generation receives confirmation and the explicit multi_rename_foo_new target,

Then the migration renames the selected table and creates the unrelated table without dropping or recreating the renamed table.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-092`.

Status: source extracted from the existing table-rename case; executable verification pending.
