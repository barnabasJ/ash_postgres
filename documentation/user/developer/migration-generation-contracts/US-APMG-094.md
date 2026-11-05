# US-APMG-094 — Move a table into a schema without recreating it

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given an initial public table gains an explicit schema in its immutable next version,

When native generation receives confirmation of the schema move,

Then the migration creates the destination schema, moves the existing table there, and reverses the move to public without dropping or recreating the table.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-094`.

Status: source extracted from the existing table-rename case; executable verification pending.
