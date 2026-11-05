# US-APMG-058 — An explicit migration type does not modify unrelated columns

As a developer, I need explicit migration types to preserve sizes and avoid unrelated changes.

Given persisted string columns blibs and blobs and an immutable next resource changing only blibs to varchar size 255,

When native generation writes the follow-up migration,

Then the actual migration modifies blibs with size 255 and contains no modify operation for blobs.

Owning case: `test/migration_generator_varchar_test.exs`, story tag `US-APMG-058`.

Status: source migrated; executable verification pending.
