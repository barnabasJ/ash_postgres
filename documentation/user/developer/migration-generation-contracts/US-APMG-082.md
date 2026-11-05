# US-APMG-082 — Commented removals show the safeguard escalation

As a developer, I need migration review messages to match the actual safety mode and generated operations.

Given an actual initial title column and an immutable next resource without it,

When native generation runs with dont_drop_columns true,

Then the migration comments out the removal and captured output contains baseline and commented-step warnings without destructive escalation.

Owning case: `test/migration_generator_review_warnings_test.exs`, story tag `US-APMG-082`.

Status: source migrated; executable verification pending.
