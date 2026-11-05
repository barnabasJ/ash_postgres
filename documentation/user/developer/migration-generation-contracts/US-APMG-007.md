# US-APMG-007 — PostgreSQL 18 selects the native UUID default

As a developer, I need UUIDv7 primary-key migrations to use the server's native function when my repository declares PostgreSQL 18 support.

Given a real repository whose fixed callbacks declare PostgreSQL 18 and native UUIDv7 support,

When native generation writes its UUIDv7 resource migration and snapshot,

Then the persisted snapshot is valid JSON and the primary key uses the uuidv7() SQL default. This capability is configured through native repository callbacks without changing global environment values.

Owning case: `test/migration_generator_native_uuid_test.exs`, story tag `US-APMG-007`.

Status: source migrated; executable verification pending.
