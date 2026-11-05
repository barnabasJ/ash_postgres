# US-APMG-024 — New required fields retain their nullability

As a developer, I need new required fields to keep their declared nullability.

Given an initial title resource and a next resource with required name,

When native generation writes the follow-up migration,

Then the generated SQL adds name as text with null false.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-024`.

Status: source migrated; executable verification pending.
