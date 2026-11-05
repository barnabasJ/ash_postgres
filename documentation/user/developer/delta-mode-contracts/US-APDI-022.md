# US-APDI-022 — answering 'no' to the drop prompt writes an OptOutDropTable delta

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through drop table opt-out in delta mode.

## Scenario

Given one resource disappears while a second resource keeps the repository discoverable.
When the native drop-table prompt receives no.
Then an OptOutDropTable delta records the decision and reduction preserves it.

Coverage: `US-APDI-022` in `test/delta_mode_drop_opt_out_test.exs`.
