# US-APDI-003 — initial codegen produces a v2 delta with CreateTable + AddAttribute ops

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through basic codegen.

## Scenario

Given an ID/title resource has no snapshots.
When native delta generation writes its initial snapshot.
Then the v2 delta contains one CreateTable and AddAttribute entries for ID and title.

Coverage: `US-APDI-003` in `test/delta_mode_basic_codegen_test.exs`.
