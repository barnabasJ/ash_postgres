# US-APMG-049 — Tenant table creation retains declared PostgreSQL options

As a developer, I need declared storage options to survive native migration generation.

Given a real context-multitenant posts resource declaring PARTITION BY RANGE (id),

When native generation writes its tenant migration,

Then the actual create-table SQL retains both the runtime tenant prefix and partition option.

Owning case: `test/migration_generator_create_table_options_test.exs`, story tag `US-APMG-049`.

Status: source migrated; executable verification pending.
