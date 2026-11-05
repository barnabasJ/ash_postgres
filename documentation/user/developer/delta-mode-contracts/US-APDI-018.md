# US-APDI-018 — conflicting deltas (same attribute added in two 'branches') raise ConflictError

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through parallel branches — merge-friendly deltas.

## Scenario

Given two branch deltas add the same attribute incompatibly.
When the combined chain is reduced.
Then the reducer raises its contextual ConflictError.

Coverage: `US-APDI-018` in `test/delta_mode_branches_test.exs`.
