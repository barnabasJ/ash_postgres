# US-APDI-036 — polymorphic resources land in concrete-table snapshot dirs and produce runnable migrations

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through generated migrations are runnable.

## Scenario

Given a static polymorphic relationship supplies a concrete destination table.
When native delta snapshots and generated migration modules run in Sandbox.
Then the concrete tables and columns exist after up and disappear after down.

Coverage: `US-APDI-036` in `test/delta_mode_runnable_sql_test.exs`.
