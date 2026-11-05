# US-APMG-042 — Codegen checks identify remaining development migrations

As a developer, I need codegen checks to report actionable pending work without changing migration files.

Given real persisted initial files followed by a generated development migration in this case’s own directory,

When the next native generation runs with check true,

Then it exits with shutdown code one, reports remaining development migrations on native stderr, and leaves those same development files intact.

Owning case: `test/migration_generator_check_test.exs`, story tag `US-APMG-042`.

Status: source migrated; executable verification pending.
