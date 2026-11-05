# US-APMG-088 — Dry-run output includes the baseline review reminder

As a developer, I need migration review messages to match the actual safety mode and generated operations.

Given a real additive resource declaration,

When native generation runs with dry_run true,

Then captured output includes the baseline manual-review reminder without a warning escalation.

Owning case: `test/migration_generator_review_warnings_test.exs`, story tag `US-APMG-088`.

Status: source migrated; executable verification pending.
