# US-APMG-115 — Keep all-tenant identities independent of tenant columns

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a tenant-scoped users resource defines a unique name identity with all_tenants?: true,

When the native generator writes its migration,

Then the unique index contains name without adding org_id.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-115`.

Status: source extracted from the existing reference case; executable verification pending.
