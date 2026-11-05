# US-APDI-029 — check constraint produces identical migration in both modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given a static resource declares a check constraint.
When full and delta modes generate independent migrations.
Then their constraint bodies match.

Coverage: `US-APDI-029` in `test/delta_mode_parity_test.exs`.
