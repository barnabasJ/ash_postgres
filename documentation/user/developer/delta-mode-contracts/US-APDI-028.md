# US-APDI-028 — custom index produces identical CREATE INDEX migration in both modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given a static resource declares a custom index.
When full and delta modes generate independent migrations.
Then their CREATE INDEX bodies match.

Coverage: `US-APDI-028` in `test/delta_mode_parity_test.exs`.
