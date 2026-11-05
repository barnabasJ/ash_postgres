# US-APMG-057 — Binary storage changes preserve the declared size

As a developer, I need explicit migration types to preserve sizes and avoid unrelated changes.

Given a persisted text column and an immutable next resource selecting binary size 500,

When native generation writes the follow-up migration,

Then the actual migration contains the binary size 500 modification and the prior text modification.

Owning case: `test/migration_generator_varchar_test.exs`, story tag `US-APMG-057`.

Status: source migrated; executable verification pending.
