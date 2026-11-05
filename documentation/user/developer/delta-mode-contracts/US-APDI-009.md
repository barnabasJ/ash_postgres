# US-APDI-009 — renaming a table produces a RenameTable op

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through structural changes.

## Scenario

Given a persisted resource changes its table name.
When native generation receives the authored table-rename answer.
Then a RenameTable operation records the old and new table names.

Coverage: `US-APDI-009` in `test/delta_mode_structural_changes_test.exs`.
