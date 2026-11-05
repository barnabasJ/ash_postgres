# US-APMG-011 — Concurrent indexes use a separate migration

As a developer, I need concurrent index creation to run outside the table migration's transaction.

Given a real resource with a custom title index declared concurrently true,

When native generation writes the resource migrations,

Then there are two resource migration files and the second contains both disable_ddl_transaction true and the concurrent title-index SQL.

Owning case: `test/migration_generator_concurrent_indexes_test.exs`, story tag `US-APMG-011`.

Status: source migrated; executable verification pending.
