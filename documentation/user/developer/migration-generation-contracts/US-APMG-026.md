# US-APMG-026 — Declined single-field renames add the new field

As a developer, I need my declined field rename to add the newly declared field.

Given an initial title and a next resource containing name instead,

When the developer declines the native rename prompt,

Then the migration adds name as text rather than treating it as the confirmed rename.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-026`.

Status: source migrated; executable verification pending.
