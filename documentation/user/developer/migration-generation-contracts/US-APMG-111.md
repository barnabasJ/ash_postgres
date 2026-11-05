# US-APMG-111 — Avoid duplicate tenant columns in reference indexes

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a multitenant posts resource indexes the same org reference used as its tenant attribute,

When the native generator writes its migration,

Then both forward and reverse index operations contain org_id once.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-111`.

Status: source extracted from the existing reference case; executable verification pending.
