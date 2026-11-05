# US-APMG-015 — Explicitly named split migrations remain unique

As a developer, I need concurrent-index migration splitting to produce distinct files and modules even when I supply one explicit migration name.

Given a real concurrent-index resource and the explicit generation name repro_case,

When native generation writes both resource migration files,

Then the file names without timestamps differ and the actual defined module names differ.

Owning case: `test/migration_generator_named_concurrent_indexes_test.exs`, story tag `US-APMG-015`.

Status: source migrated; executable verification pending.
