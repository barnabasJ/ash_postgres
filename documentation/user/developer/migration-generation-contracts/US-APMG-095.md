# US-APMG-095 — Move a table before altering it under the new schema

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given an initial public table gains both an explicit schema and a subject column,

When native generation receives confirmation of the schema move,

Then ALTER TABLE SET SCHEMA precedes the alteration under the new prefix, the subject column is added, and the table is not dropped or recreated.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-095`.

Status: source extracted from the existing table-rename case; executable verification pending.
