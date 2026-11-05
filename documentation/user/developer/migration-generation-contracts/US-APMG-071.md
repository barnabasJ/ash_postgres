# US-APMG-071 — PK changes preserve dependent FK ordering

As a developer, I need dependent foreign keys to remain valid while a referenced resource changes its primary key.

Given actual persisted Post/Comment snapshots and a complete immutable next graph whose Post primary key changes from id to guid,

When native generation compares the next graph with the stored history,

Then the Comment FK is dropped before the Post primary-key constraint, and the generated modifications retain the original id nullability/key change and Post reference SQL.

Owning case: `test/migration_generator_primary_key_reference_test.exs`, story tag `US-APMG-071`.

Status: source migrated; executable verification pending.
