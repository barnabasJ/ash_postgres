# US-APDI-014 — references (belongs_to) round-trip through delta encode + reduce

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through identities, indexes, constraints, references.

## Scenario

Given two static resources have a belongs_to relationship.
When generation writes and the reducer reads the actual encoded delta chain.
Then the destination reference remains attached to the source attribute.

Coverage: `US-APDI-014` in `test/delta_mode_constraints_test.exs`.
