# US-APDI-038 — squashed delta produces a migration that creates the same schema

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through generated migrations are runnable.

## Scenario

Given an evolved resource has a squashed delta snapshot.
When native generation compares the unchanged resource against that snapshot with an empty fresh migration directory.
Then no new migration appears; this case checks file behavior rather than executing SQL.

Coverage: `US-APDI-038` in `test/delta_mode_runnable_test.exs`.
