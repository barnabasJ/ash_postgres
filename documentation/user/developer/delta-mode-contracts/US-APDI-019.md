# US-APDI-019 — real sequential codegen on diverged branches produces deltas that merge cleanly

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through parallel branches — merge-friendly deltas.

## Scenario

Given actual codegen produces independent resource changes on two copied branch histories.
When the generated artifacts are merged, reduced and run through the native Runner in Sandbox.
Then the combined schema contains both additions, unchanged generation emits nothing and rollback removes the table.

Coverage: `US-APDI-019` in `test/delta_mode_branches_sql_test.exs`.
