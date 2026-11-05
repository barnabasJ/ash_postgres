# US-APMG-089 — Rename a resource table without recreating it

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given an initial messages table snapshot and an immutable next version with a new table name,

When native generation receives confirmation of the table rename,

Then a new migration renames the table without dropping the original table or creating the renamed table.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-089`.

Status: source extracted from the existing table-rename case; executable verification pending.
