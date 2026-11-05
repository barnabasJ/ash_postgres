# US-APMG-099 — Keep foreign keys intact when their referenced table moves schema

As a developer, I need native migration generation to preserve table data and foreign keys when resource table or schema names change.

Given native snapshots of an author table and its required referencing posts are compared with immutable versions whose author table moves schema,

When the native snapshot operation APIs build forward and reverse SQL,

Then the author table moves reversibly between public and its explicit schema without recreating either table or dropping or recreating their foreign key.

Owning case: `test/migration_generator_table_renames_test.exs`, story tag `US-APMG-099`.

Status: source extracted from the existing table-rename case; executable verification pending.
