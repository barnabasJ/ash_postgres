# US-APMG-029 — Declining a multiple-candidate rename adds the new fields

As a developer, I need my declined multiple-candidate rename to add the required subject field.

Given an initial title and a next resource with multiple candidate new attributes,

When the developer declines the native rename prompt,

Then the generated SQL adds subject as a new text field with null false.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-029`.

Status: source migrated; executable verification pending.
