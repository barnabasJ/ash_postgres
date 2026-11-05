# US-APDI-005 — codegen with no changes does not emit any new delta files

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through basic codegen.

## Scenario

Given an unchanged resource already has its initial delta.
When the same static domain is generated again.
Then the snapshot and migration chains gain no changes.

Coverage: `US-APDI-005` in `test/delta_mode_basic_codegen_test.exs`.
