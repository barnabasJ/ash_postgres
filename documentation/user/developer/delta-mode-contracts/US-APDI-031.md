# US-APDI-031 — attribute multitenancy produces identical migration in both modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given static related resources use attribute multitenancy.
When full and delta modes generate independent migrations.
Then the generated tenancy-aware migration bodies match.

Coverage: `US-APDI-031` in `test/delta_mode_parity_test.exs`.
