# US-APMG-084 — Uncommented column removal shows destructive escalation

As a developer, I need migration review messages to match the actual safety mode and generated operations.

Given an actual initial title column and an immutable next resource without it,

When native generation writes the uncommented removal,

Then the actual migration removes title and output contains baseline plus destructive escalation without a commented-step warning.

Owning case: `test/migration_generator_review_warnings_test.exs`, story tag `US-APMG-084`.

Status: source migrated; executable verification pending.
