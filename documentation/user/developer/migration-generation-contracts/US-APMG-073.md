# US-APMG-073 — New tenant columns precede their identity indexes

As a developer, I need tenant and removal migrations to preserve explicit choices and dependency order.

Given persisted Shop/Event tables and an immutable next graph adding tenant-scoped Ticket with its shop relationship and code identity,

When native generation writes the actual follow-up migration,

Then both shop_id and its composite unique index appear and the column is added before that index.

Owning case: `test/migration_generator_tenant_identity_test.exs`, story tag `US-APMG-073`.

Status: source migrated; executable verification pending.
