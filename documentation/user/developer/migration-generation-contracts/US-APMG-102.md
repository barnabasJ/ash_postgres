# US-APMG-102 — Create a unique index before its dependent foreign key

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given a template-phase resource has a composite primary key, an id identity, and a nullable self-reference through follows,

When the native generator writes the initial migration,

Then the template_phase id unique index appears before the dependent follows foreign-key modification.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-102`.

Status: source extracted from the existing reference case; executable verification pending.
