# US-APMG-001 — Empty resources produce no migration or snapshot

As a developer, I need migration generation to ignore resources with no stored attributes so it does not create empty SQL tables.

Given a real AshPostgres resource with no attributes and no required primary key,

When `AshPostgres.MigrationGenerator.generate/2` runs against that resource's domain,

Then no resource migration or resource snapshot is generated. Extension migration files do not count as resource migrations.

Owning case: `test/migration_generator_empty_resources_test.exs`, story tag `US-APMG-001`.

Status: source migrated; executable verification pending.
