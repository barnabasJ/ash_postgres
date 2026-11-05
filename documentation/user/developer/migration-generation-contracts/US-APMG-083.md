# US-APMG-083 — Confirmed table drops show destructive escalation

As a developer, I need migration review messages to match the actual safety mode and generated operations.

Given actual keep/drop table snapshots and a next domain retaining only the keep table,

When the developer confirms the native drop prompt,

Then the actual migration drops the removed table and output contains baseline plus destructive escalation without a commented-step warning.

Owning case: `test/migration_generator_review_warnings_test.exs`, story tag `US-APMG-083`.

Status: source migrated; executable verification pending.
