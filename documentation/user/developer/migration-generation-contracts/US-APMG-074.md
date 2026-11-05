# US-APMG-074 — Confirmed table removal drops the table and its snapshot

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given actual persisted Post and Message tables and a next domain retaining only Post,

When the developer confirms the native drop prompt,

Then the follow-up drops Message, removes only its orphan snapshot directory and retains the Post snapshot.

Owning case: `test/migration_generator_table_drops_test.exs`, story tag `US-APMG-074`.

Status: source migrated; executable verification pending.
