# US-APMG-048 — Regular table creation retains declared PostgreSQL options

As a developer, I need declared storage options to survive native migration generation.

Given a real posts resource declaring PARTITION BY RANGE (id),

When native generation writes its regular migration,

Then the actual create-table SQL retains the partition option.

Owning case: `test/migration_generator_create_table_options_test.exs`, story tag `US-APMG-048`.

Status: source migrated; executable verification pending.
