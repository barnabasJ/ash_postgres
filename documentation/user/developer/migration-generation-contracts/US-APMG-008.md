# US-APMG-008 — Native UUID support omits the obsolete extension function

As a developer, I need generated Ash extension migrations to avoid replacing a UUID function already supplied by the server.

Given a real repository whose fixed callbacks enable native PostgreSQL 18 UUIDv7 support,

When its actual generated extension migration is selected by its owning repository's module,

Then exactly one owned file includes the required Ash functions and does not create uuid_generate_v7. Other configured repositories retain their own declared capabilities. This case does not change them through global environment values.

Owning case: `test/migration_generator_native_uuid_test.exs`, story tag `US-APMG-008`.

Status: source migrated; executable verification pending.
