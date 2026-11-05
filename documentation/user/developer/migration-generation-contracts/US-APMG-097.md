# US-APMG-097 — Move an existing table between explicit schemas

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given an initial table under old_message_schema moves to new_message_schema in its immutable next version,

When native generation receives confirmation of the schema move,

Then the migration creates the destination schema and emits reversible schema-qualified moves without dropping or recreating the table.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-097`.

Status: source extracted from the existing table-rename case; executable verification pending.
