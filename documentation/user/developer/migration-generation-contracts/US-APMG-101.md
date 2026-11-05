# US-APMG-101 — Infer UUID foreign keys

As a developer, I need reference migrations to preserve their declared database constraints and indexes.

Given two resources share the posts table and one belongs to the other by UUID,

When the native migration generator writes their initial migration,

Then the generated reference targets posts.id with UUID type, the public prefix, and the inferred foreign-key name.

Owning case: `test/migration_generator_references_test.exs`, story tag `US-APMG-101`.

Status: source extracted from the existing reference case; executable verification pending.
