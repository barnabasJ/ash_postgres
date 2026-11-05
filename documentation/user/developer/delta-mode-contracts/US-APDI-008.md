# US-APDI-008 — altering an attribute (type change) produces an AlterAttribute op

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through structural changes.

## Scenario

Given a persisted resource changes an attribute type.
When the generator compares static before and after resource versions.
Then the emitted AlterAttribute preserves the intended source and type change.

Coverage: `US-APDI-008` in `test/delta_mode_structural_changes_test.exs`.
