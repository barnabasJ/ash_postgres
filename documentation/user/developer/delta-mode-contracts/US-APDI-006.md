# US-APDI-006 — removing an attribute produces a RemoveAttribute op that reduces correctly

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through structural changes.

## Scenario

Given a resource snapshot includes a field that its evolved definition removes.
When native generation emits the removal and the stored deltas are reduced.
Then the removal operation and reduced attribute set match the evolved resource.

Coverage: `US-APDI-006` in `test/delta_mode_structural_changes_test.exs`.
