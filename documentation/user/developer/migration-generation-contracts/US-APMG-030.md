# US-APMG-030 — Resources sharing one table contribute all added attributes

As a developer, I need all resources sharing one table to contribute their declared fields.

Given two real next-version resources sharing posts, one adding foobar and the other contributing name,

When native generation compares their combined storage declaration with the persisted initial snapshot,

Then the follow-up migration adds both foobar and name.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-030`.

Status: source migrated; executable verification pending.
