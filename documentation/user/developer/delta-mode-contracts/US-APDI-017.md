# US-APDI-017 — two deltas from separate 'branches' merge cleanly and reduce to combined state

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through parallel branches — merge-friendly deltas.

## Scenario

Given two independent branch deltas add different attributes to the same base.
When the branches are combined and reduced before generating from the merged definition.
Then all attributes survive and unchanged merged generation emits no additional migration.

Coverage: `US-APDI-017` in `test/delta_mode_branches_test.exs`.
