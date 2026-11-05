# US-APMG-032 — Concurrent identity changes produce a separate index migration

As a developer, I need concurrent identities to run in their own nontransactional migration.

Given a persisted initial title identity and a next resource with unique_title and unique_name identities,

When native generation runs with concurrent_indexes true,

Then the third resource migration disables DDL transactions and creates both named unique indexes concurrently.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-032`.

Status: source migrated; executable verification pending.
