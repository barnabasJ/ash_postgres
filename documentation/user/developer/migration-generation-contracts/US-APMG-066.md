# US-APMG-066 — Shared checks combine their declared base filters

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given two real resources sharing a constraint name and check under different base filters,

When native generation combines their declarations,

Then the actual constraint SQL retains the required composition of both resource base filters.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-066`.

Status: source migrated; executable verification pending.
