# US-APMG-021 — Indexed attribute rename avoids an unrelated modify

As a developer, I need renaming an indexed attribute to avoid unrelated type modifications.

Given an initial indexed title and a next resource whose identity targets renamed foobar,

When native generation receives confirmation of the rename,

Then the follow-up migration does not contain a modify operation.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-021`.

Status: source migrated; executable verification pending.
