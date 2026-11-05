# US-APMG-123 — Infer simple tenant matching for nullable references

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a nullable primary-key user reference enables match_tenant? under attribute multitenancy,

When the native generator writes its migration,

Then the foreign key includes org_id tenant matching and simple match type.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-123`.

Status: source extracted from the existing reference case; executable verification pending.
