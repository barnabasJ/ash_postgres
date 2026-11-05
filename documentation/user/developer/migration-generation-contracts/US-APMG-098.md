# US-APMG-098 — Decline a move between explicit schemas

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given an initial table under an explicit schema moves to a different schema in its immutable next version,

When native generation receives declined move and drop answers,

Then the migration creates the destination-schema table without moving or dropping the original schema-qualified table.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-098`.

Status: source extracted from the existing table-rename case; executable verification pending.
