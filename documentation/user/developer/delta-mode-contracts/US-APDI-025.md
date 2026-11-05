# US-APDI-025 — creating a resource produces identical migrations in full and delta modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given the same static initial resource can be generated in full and delta modes.
When both native generators write their migrations.
Then their migration bodies match.

Coverage: `US-APDI-025` in `test/delta_mode_parity_test.exs`.
