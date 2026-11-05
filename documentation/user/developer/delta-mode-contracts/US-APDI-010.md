# US-APDI-010 — renaming a table, reducing, and generating a follow-up delta succeeds

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through structural changes.

## Scenario

Given a resource has moved to a new table name.
When the renamed state is reduced and a later static version adds another field.
Then follow-up generation succeeds and produces only the intended new field.

Coverage: `US-APDI-010` in `test/delta_mode_structural_changes_test.exs`.
