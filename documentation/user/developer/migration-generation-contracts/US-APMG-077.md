# US-APMG-077 — Resources excluded from migration do not become drop candidates

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given actual managed resource snapshots and an immutable next resource marked migrate false,

When native generation compares the still-present resource graph,

Then no drop prompt or new migration is emitted and the externally managed snapshot remains.

Owning case: `test/migration_generator_table_drops_test.exs`, story tag `US-APMG-077`.

Status: source migrated; executable verification pending.
