# US-APMG-056 — Changing varchar size preserves both declared sizes

As a developer, I need explicit migration types to preserve sizes and avoid unrelated changes.

Given a persisted varchar size 100 column and an immutable next resource selecting size 255,

When native generation writes the follow-up migration,

Then the actual migration contains both varchar size 255 and prior size 100 modifications.

Owning case: `test/migration_generator_varchar_test.exs`, story tag `US-APMG-056`.

Status: source migrated; executable verification pending.
