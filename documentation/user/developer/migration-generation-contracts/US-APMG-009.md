# US-APMG-009 — Initial snapshots retain the complete resource contract

As a developer, I need initial migration generation to preserve my resource's storage declarations.

Given a real resource with composite UUID keys, a newtype email, an explicit varchar size, a migration default, a sourced attribute, custom indexes and multi-attribute identities,

When native generation writes its initial snapshot and SQL migration,

Then the snapshot is valid JSON and the generated table includes both primary-key defaults, the declared text and citext types, the varchar size, the explicit default, custom indexes and unique identity indexes using the stored source names.

Owning case: `test/migration_generator_initial_snapshots_test.exs`, story tag `US-APMG-009`.

Status: source migrated; executable verification pending.
