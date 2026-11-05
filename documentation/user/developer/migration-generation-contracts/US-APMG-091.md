# US-APMG-091 — Preserve the schema prefix in table renames

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given a resource table and its immutable renamed version use the same explicit schema,

When native generation receives confirmation of the table rename,

Then both the source and destination table expressions retain that schema prefix.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-091`.

Status: source extracted from the existing table-rename case; executable verification pending.
