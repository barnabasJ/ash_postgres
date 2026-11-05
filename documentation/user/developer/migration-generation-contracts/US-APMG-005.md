# US-APMG-005 — Stored datetime instants survive a timezone change

As a developer, I need persisted timestamptz values to represent the same instant when the database session uses another timezone.

Given a datetime persisted through the real resource create action,

When the test transaction sets its timezone locally to America/Los_Angeles and reads that record through Ash,

Then the loaded datetime equals the original instant. The transaction-local setting ends with the normal SQL Sandbox transaction.

Owning case: `test/migration_generator_timestamptz_test.exs`, story tag `US-APMG-005`.

Status: source migrated; executable verification pending.
