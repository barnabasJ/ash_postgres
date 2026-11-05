# US-APDI-020 — generate → squash → generate yields no drift

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through squash in delta mode.

## Scenario

Given a resource has a generated delta chain.
When the native squash task rewrites that chain and unchanged codegen runs again.
Then the squashed state produces no migration drift.

Coverage: `US-APDI-020` in `test/delta_mode_squash_test.exs`.
