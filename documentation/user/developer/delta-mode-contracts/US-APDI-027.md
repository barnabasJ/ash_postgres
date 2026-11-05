# US-APDI-027 — removing an attribute produces identical DROP COLUMN migration in both modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given a static evolved resource removes an attribute.
When full and delta modes generate the removal from their own prior histories.
Then both emit matching DROP COLUMN migration bodies.

Coverage: `US-APDI-027` in `test/delta_mode_parity_test.exs`.
