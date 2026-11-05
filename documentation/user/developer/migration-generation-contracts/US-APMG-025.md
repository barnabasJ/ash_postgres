# US-APMG-025 — Confirmed single-field renames generate rename SQL

As a developer, I need my confirmed field rename to become SQL rename operations.

Given an initial title and a next resource containing name instead,

When the developer confirms the native rename prompt,

Then the migration renames title to name.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-025`.

Status: source migrated; executable verification pending.
