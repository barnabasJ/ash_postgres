# US-APMG-020 — Composite primary keys can shrink and be restored

As a developer, I need schema-qualified composite primary-key changes to preserve their complete membership in both directions.

Given a persisted example.posts table with primary key id/title and immutable subsequent resources that remove then restore title,

When native generation runs through both changes using the actual persisted snapshot history,

Then the first migration adds the id-only primary key and its reverse restores id/title. The next migration restores id/title and its reverse restores id alone, with the original schema-qualified SQL and constraint handling.

Owning case: `test/migration_generator_composite_primary_key_test.exs`, story tag `US-APMG-020`.

Status: source migrated; executable verification pending.
