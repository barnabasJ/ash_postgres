# US-APMG-033 — A column absent from another shared-table resource stays nullable

As a developer, I need a field missing from another shared-table resource to remain nullable.

Given two real resources sharing posts where only one declares required example,

When native generation combines their storage declarations,

Then the follow-up adds example as text without null false.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-033`.

Status: source migrated; executable verification pending.
