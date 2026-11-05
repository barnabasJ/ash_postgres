# US-APMG-075 — A second generation after a drop is a no-op

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given an actual initial SoloPost table followed by a confirmed drop and creation of OtherResource,

When native generation runs a third time against the unchanged next domain,

Then the drop/add created a new migration, the third run reports no changes and its migration-file count stays unchanged.

Owning case: `test/migration_generator_table_drops_test.exs`, story tag `US-APMG-075`.

Status: source migrated; executable verification pending.
