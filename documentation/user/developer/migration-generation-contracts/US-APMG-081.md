# US-APMG-081 — Additive migrations show the baseline review reminder

As a developer, I need migration review messages to match the actual safety mode and generated operations.

Given a real additive resource declaration,

When native generation writes its migration in normal review mode,

Then captured output contains the baseline manual-review reminder without a warning escalation.

Owning case: `test/migration_generator_review_warnings_test.exs`, story tag `US-APMG-081`.

Status: source migrated; executable verification pending.
