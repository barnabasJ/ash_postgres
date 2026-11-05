# US-APDI-026 — evolving a resource (add + alter + index) produces identical migrations

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given the same static before and after resources add a field, alter nullability and add an identity.
When both full and delta mode generate the complete evolution.
Then the resulting migration bodies match.

Coverage: `US-APDI-026` in `test/delta_mode_parity_test.exs`.
