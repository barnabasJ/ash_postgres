# US-APMG-055 — Adding varchar storage preserves its size and prior type

As a developer, I need explicit migration types to preserve sizes and avoid unrelated changes.

Given a persisted text column and an immutable next resource selecting varchar size 255,

When native generation writes the follow-up migration,

Then the actual migration contains varchar size 255 and the prior text modification for reversal.

Owning case: `test/migration_generator_varchar_test.exs`, story tag `US-APMG-055`.

Status: source migrated; executable verification pending.
