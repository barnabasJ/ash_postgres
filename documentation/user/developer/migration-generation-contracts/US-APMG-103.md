# US-APMG-103 — Infer the destination attribute type

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given the posts resources use string primary keys and a string belongs-to attribute,

When the native generator writes the initial migration,

Then the inferred foreign key uses PostgreSQL text rather than UUID.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-103`.

Status: source extracted from the existing reference case; executable verification pending.
