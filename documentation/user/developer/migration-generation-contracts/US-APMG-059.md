# US-APMG-059 — Skipped resources remain visible in the no-change report

As a developer, I need migration generation to explain skipped work and preserve persisted extension numbering.

Given a real resource whose migrate flag is false and the extension output from the first native generation,

When native generation runs again against the actual case-owned paths,

Then the captured native output reports both no changes and that resources were skipped because migrate is false.

Owning case: `test/migration_generator_skipped_resources_test.exs`, story tag `US-APMG-059`.

Status: source migrated; executable verification pending.
