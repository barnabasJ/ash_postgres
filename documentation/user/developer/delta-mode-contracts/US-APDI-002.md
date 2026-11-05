# US-APDI-002 — Apply incremental generated delta migration

As a developer, I need a second generated migration to add a column without applying the initial table migration again.

## Scenario

Given native delta generation for an immutable initial resource has produced a uniquely named migration, and its compiled module has created the table with a title but no body.
When an immutable evolved resource adds body, the test generates a second native migration, compiles only that new artifact and revisits the full case-local migration list.
Then two delta snapshots exist, body exists after the incremental migration, and reversing the retained compiled modules removes the table.

Coverage: `AshPostgres.DeltaModeRunnableMigrationsTest`, `test/delta_mode_runnable_migrations_test.exs`.
