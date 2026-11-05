# US-APMG-063 — Constraint removal precedes related table modification

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given an initial real resource with a check constraint and an immutable next resource without it,

When native generation writes the follow-up migration,

Then the constraint drop precedes the relevant table modification in actual generated SQL.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-063`.

Status: source migrated; executable verification pending.
