# US-APMG-112 — Replace single-column indexes when acquiring multitenancy

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a token resource initially indexes its user reference without multitenancy and the next version acquires org attribute multitenancy,

When native generation compares the two immutable versions,

Then the follow-up drops the user_id index and creates the composite org_id and user_id index.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-112`.

Status: source extracted from the existing reference case; executable verification pending.
