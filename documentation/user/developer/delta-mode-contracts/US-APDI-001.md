# US-APDI-001 — Run and roll back initial delta migration

As a developer, I need generated delta migrations to create the intended schema and reverse it cleanly.

## Scenario

Given a static resource has an ID, title and body, and native delta generation writes a uniquely named migration in the case's temporary directory.
When the test compiles that actual file once and runs its returned migration module up and down through the native migration Runner in SQL Sandbox.
Then the table and all three columns exist after up, and the table is absent after down.

Coverage: `AshPostgres.DeltaModeRunnableMigrationsTest`, `test/delta_mode_runnable_migrations_test.exs`.
