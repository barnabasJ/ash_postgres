# US-APMG-065 — An unfiltered check is not wrapped by another resource’s filter

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given two real resources sharing one table where the complete constraint has no base filter and the other resource has a filter,

When native generation combines their declarations,

Then the actual check retains its authored unfiltered SQL rather than gaining the other resource’s base-filter wrapper.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-065`.

Status: source migrated; executable verification pending.
