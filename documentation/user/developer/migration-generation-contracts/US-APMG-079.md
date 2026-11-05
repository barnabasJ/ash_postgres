# US-APMG-079 — Dependent tables are dropped before referenced tables

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given actual Company/Project/Task snapshots and an unchanged keepalive resource,

When the developer confirms removal of all three dependent tables,

Then the actual migration drops Task before Project and Project before Company.

Owning case: `test/migration_generator_table_drops_test.exs`, story tag `US-APMG-079`.

Status: source migrated; executable verification pending.
