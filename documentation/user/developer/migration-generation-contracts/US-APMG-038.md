# US-APMG-038 — Context-tenant composite keys retain tenant prefixes

As a developer, I need schema and tenant identity to survive reversible resource changes.

Given immutable context-multitenant resource versions that add title to the id primary key,

When native generation processes both versions through their persisted tenant snapshot history,

Then the tenant migration adds primary key id/title using the runtime prefix and its reverse restores id alone.

Owning case: `test/migration_generator_tenant_composite_key_test.exs`, story tag `US-APMG-038`.

Status: source migrated; executable verification pending.
