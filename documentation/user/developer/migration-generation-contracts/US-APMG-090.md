# US-APMG-090 — Propose a rename despite an empty target snapshot directory

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given an initial messages table snapshot and an empty directory for its next table name,

When native generation receives confirmation of the table rename,

Then the migration renames the original table rather than creating a replacement table.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-090`.

Status: source extracted from the existing table-rename case; executable verification pending.
