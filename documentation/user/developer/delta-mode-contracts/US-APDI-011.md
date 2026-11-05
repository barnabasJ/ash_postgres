# US-APDI-011 — adding an identity (unique constraint) produces AddUniqueIndex ops

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through identities, indexes, constraints, references.

## Scenario

Given a resource starts without a unique identity.
When a static version adds an identity and generates a delta.
Then the delta includes the intended AddUniqueIndex.

Coverage: `US-APDI-011` in `test/delta_mode_constraints_test.exs`.
