# US-APDI-012 — adding a custom index produces an AddCustomIndex op

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through identities, indexes, constraints, references.

## Scenario

Given a resource declares a custom index.
When native delta generation runs against the resource definition.
Then the stored operations contain the custom index.

Coverage: `US-APDI-012` in `test/delta_mode_constraints_test.exs`.
