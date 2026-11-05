# US-APMG-060 — Extension migrations increment past the persisted sequence

As a developer, I need migration generation to explain skipped work and preserve persisted extension numbering.

Given an actual extension migration file numbered one in this case’s migration directory,

When native generation writes extension migrations using the same directory,

Then every newly generated extension file has sequence two in its basename and defines the corresponding MigrateResourcesExtensions2 module.

Owning case: `test/migration_generator_extension_numbering_test.exs`, story tag `US-APMG-060`.

Status: source migrated; executable verification pending.
