# US-APDI-032 — schema-prefixed table produces identical migration in both modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given a static resource uses an explicit schema prefix.
When full and delta modes generate independent migrations.
Then their schema-prefixed migration bodies match.

Coverage: `US-APDI-032` in `test/delta_mode_parity_test.exs`.
