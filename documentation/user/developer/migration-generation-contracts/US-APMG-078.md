# US-APMG-078 — Confirmed schema-qualified drops retain their prefix

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given an actual schema-qualified table and a next domain that no longer includes that resource,

When the developer confirms its native drop prompt,

Then the actual drop migration retains the original schema prefix.

Owning case: `test/migration_generator_table_drops_test.exs`, story tag `US-APMG-078`.

Status: source migrated; executable verification pending.
