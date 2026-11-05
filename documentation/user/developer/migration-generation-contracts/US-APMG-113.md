# US-APMG-113 — Replace composite indexes when removing multitenancy

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a token resource initially indexes its user reference under org attribute multitenancy and the next version removes multitenancy,

When native generation compares the two immutable versions,

Then the follow-up drops the composite org_id and user_id index and creates the user_id index.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-113`.

Status: source extracted from the existing reference case; executable verification pending.
