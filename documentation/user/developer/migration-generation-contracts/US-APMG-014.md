# US-APMG-014 — A dependent FK follows its concurrent unique index

As a developer, I need a foreign key targeting a non-primary identity to be created after its concurrent unique index exists.

Given real target and dependent resources linked through the target's unique code identity,

When native generation runs with concurrent_indexes true,

Then it emits three resource migrations: tables without that FK, the concurrent unique index with transaction and lock disabled, and the dependent FK modification with its original target, source, name, type and prefix.

Owning case: `test/migration_generator_concurrent_unique_fk_test.exs`, story tag `US-APMG-014`.

Status: source migrated; executable verification pending.
