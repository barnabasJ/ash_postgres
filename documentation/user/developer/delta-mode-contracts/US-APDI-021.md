# US-APDI-021 — post-squash incremental codegen emits the same migration as the no-squash baseline

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through squash in delta mode.

## Scenario

Given two static resource timelines evolve identically and only one is squashed.
When the final migrations are compared and each chain runs up and down in Sandbox.
Then both generated migration bodies and actual database schemas match.

Coverage: `US-APDI-021` in `test/delta_mode_squash_sql_test.exs`.
