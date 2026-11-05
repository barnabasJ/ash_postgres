# US-APDI-013 — adding a check constraint produces an AddCheckConstraint op

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through identities, indexes, constraints, references.

## Scenario

Given a resource declares a check constraint.
When native delta generation runs against that definition.
Then the stored operations include the authored check constraint.

Coverage: `US-APDI-013` in `test/delta_mode_constraints_test.exs`.
