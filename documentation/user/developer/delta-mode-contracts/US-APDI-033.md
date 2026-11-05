# US-APDI-033 — renaming an attribute produces identical RENAME migration in both modes

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migration-content parity (delta vs full).

## Scenario

Given a static resource evolution renames an attribute.
When full and delta modes each receive yes through their native rename prompt.
Then the generated RENAME migration bodies match.

Coverage: `US-APDI-033` in `test/delta_mode_parity_test.exs`.
