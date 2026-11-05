# US-APMG-031 — Resources sharing one table contribute all identities

As a developer, I need all resources sharing one table to contribute their declared identities.

Given two real next-version resources sharing posts with unique_title and unique_name identities,

When native generation compares their combined declaration with the persisted initial title identity,

Then the initial migration contains the original title index and the follow-up drops it before defining both declared unique indexes.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-031`.

Status: source migrated; executable verification pending.
