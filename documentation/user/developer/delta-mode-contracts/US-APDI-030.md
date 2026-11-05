# US-APDI-030 — belongs_to references produce identical FK migration in both modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given static resources declare a belongs_to foreign key.
When full and delta modes generate independent histories.
Then the generated foreign-key migration bodies match.

Coverage: `US-APDI-030` in `test/delta_mode_parity_test.exs`.
