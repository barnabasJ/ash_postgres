# US-APMG-064 — A mapping-only constraint does not erase another resource’s check

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given two real resources sharing one table where the first only names a constraint and the second supplies its SQL check,

When native generation combines their declarations,

Then the actual migration still creates the supplied check constraint.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-064`.

Status: source migrated; executable verification pending.
