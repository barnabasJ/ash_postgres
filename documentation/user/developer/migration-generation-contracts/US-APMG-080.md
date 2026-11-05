# US-APMG-080 — Dependent foreign keys are dropped before the removed parent table

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given actual persisted parent/child snapshots and an immutable next graph retaining children without their parent relationships,

When native generation writes the development migration that removes the parent,

Then both child FK drops precede the parent-table drop in actual generated SQL.

Owning case: `test/migration_generator_table_drops_test.exs`, story tag `US-APMG-080`.

Status: source migrated; executable verification pending.
