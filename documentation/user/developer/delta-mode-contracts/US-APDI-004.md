# US-APDI-004 — adding an attribute in a follow-up codegen produces a minimal delta

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through basic codegen.

## Scenario

Given the initial ID/title resource already has a generated delta.
When a static evolved resource adds body and runs generation again.
Then the second delta contains only the body AddAttribute and no CreateTable.

Coverage: `US-APDI-004` in `test/delta_mode_basic_codegen_test.exs`.
