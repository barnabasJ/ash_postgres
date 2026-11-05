# US-APMG-110 — Include tenant columns in reference indexes

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given an attribute-multitenant posts resource indexes its post reference,

When the native generator writes its migration,

Then the reference index contains org_id before post_id.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-110`.

Status: source extracted from the existing reference case; executable verification pending.
