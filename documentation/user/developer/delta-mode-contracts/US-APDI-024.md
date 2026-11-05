# US-APDI-024 — post-migrate incremental codegen emits the same migration as the no-migrate baseline

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migrate_snapshots.

## Scenario

Given two static timelines evolve identically and only one converts legacy snapshots to deltas.
When the native conversion and follow-up codegen run, then both migration chains run in Sandbox.
Then migration bodies and resulting schemas match without conversion drift.

Coverage: `US-APDI-024` in `test/delta_mode_migrate_snapshots_sql_test.exs`.
