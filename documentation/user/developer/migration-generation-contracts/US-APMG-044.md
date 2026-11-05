# US-APMG-044 — Global attribute multitenancy preserves existing identities

As a developer, I need multitenancy capability changes to preserve valid existing schema state.

Given an actual initial attribute-multitenant posts snapshot with its title identity,

When native generation compares an immutable next resource whose global flag is true,

Then no follow-up resource migration rewrites the identity.

Owning case: `test/migration_generator_global_multitenancy_test.exs`, story tag `US-APMG-044`.

Status: source migrated; executable verification pending.
