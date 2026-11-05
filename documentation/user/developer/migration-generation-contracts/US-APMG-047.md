# US-APMG-047 — Unsupported literal defaults warn and omit an invalid SQL default

As a developer, I need declared storage options to survive native migration generation.

Given a real term attribute whose tuple default lacks EctoMigrationDefault support,

When native generation runs under native log capture,

Then the warning identifies the exact tuple value and the actual migration declares the binary column without an invalid literal default.

Owning case: `test/migration_generator_default_values_test.exs`, story tag `US-APMG-047`.

Status: source migrated; executable verification pending.
