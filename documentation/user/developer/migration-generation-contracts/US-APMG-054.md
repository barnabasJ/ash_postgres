# US-APMG-054 — Decimal foreign keys preserve target precision and scale

As a developer, I need decimal schema changes to retain their declared storage constraints.

Given a real Category decimal primary key and Product decimal foreign key with matching precision and scale,

When native generation processes their complete immutable graph,

Then the category key and the single combined add-with-reference product FK retain the original decimal precision and scale SQL.

Owning case: `test/migration_generator_decimal_test.exs`, story tag `US-APMG-054`.

Status: source migrated; executable verification pending.
