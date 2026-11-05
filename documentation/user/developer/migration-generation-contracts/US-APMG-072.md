# US-APMG-072 — Tenant identity indexes do not duplicate the tenant column

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given a real attribute-multitenant Channel whose identity already includes project_id and type,

When native generation writes the identity migration,

Then the unique index contains project_id/type once and does not repeat project_id.

Owning case: `test/migration_generator_tenant_identity_test.exs`, story tag `US-APMG-072`.

Status: source migrated; executable verification pending.
