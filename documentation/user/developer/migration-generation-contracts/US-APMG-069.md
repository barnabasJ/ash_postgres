# US-APMG-069 — Historical snapshots without constraint filters remain unchanged

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given an actual generated snapshot whose check-constraint base_filter fields are removed to represent historical storage,

When native generation reads that persisted snapshot against the same immutable resource,

Then only the original resource migration remains and no unnecessary replacement migration is generated.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-069`.

Status: source migrated; executable verification pending.
