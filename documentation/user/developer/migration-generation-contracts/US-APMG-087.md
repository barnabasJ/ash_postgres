# US-APMG-087 — No-shell mode suppresses review reminders

As a developer, I need migration review messages to match the actual safety mode and generated operations.

Given a real additive resource declaration,

When native generation runs with no_shell true,

Then captured output contains neither the baseline review reminder nor a warning prefix.

Owning case: `test/migration_generator_review_warnings_test.exs`, story tag `US-APMG-087`.

Status: source migrated; executable verification pending.
