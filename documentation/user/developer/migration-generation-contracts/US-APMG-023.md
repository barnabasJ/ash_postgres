# US-APMG-023 — Identity predicate changes replace the old index first

As a developer, I need index predicate changes to replace indexes in a safe order.

Given an initial title identity and a next resource with its new SQL where clause,

When native generation writes the follow-up migration,

Then the old named unique index is dropped before the replacement with the full new predicate.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-023`.

Status: source migrated; executable verification pending.
