# US-APMG-002 — A primary-key-only resource generates its table

As a developer, I need migration generation to preserve a resource whose only stored attribute is its primary key.

Given a real AshPostgres resource with a UUID primary key and no other attributes,

When `AshPostgres.MigrationGenerator.generate/2` runs against that resource's domain,

Then one resource migration and one resource snapshot are generated. Extension migration files do not count as resource migrations.

Owning case: `test/migration_generator_empty_resources_test.exs`, story tag `US-APMG-002`.

Status: source migrated; executable verification pending.
