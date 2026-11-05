# US-APMG-076 — Declining a drop retains its snapshot without asking again

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given actual Post/Message snapshots and a next domain that omits Message,

When the developer declines the native drop prompt and runs generation again,

Then no migration is added, Message’s snapshot remains and the second unchanged run emits no drop prompt.

Owning case: `test/migration_generator_table_drops_test.exs`, story tag `US-APMG-076`.

Status: source migrated; executable verification pending.
