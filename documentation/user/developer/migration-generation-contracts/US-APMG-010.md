# US-APMG-010 — Schema-qualified snapshots preserve predicates and indexes

As a developer, I need initial generation to preserve a resource's PostgreSQL schema and conditional identity configuration.

Given a real resource in schema example with UUID keys, custom indexes, varchar migration type and a conditional identity with nulls_distinct false,

When native generation writes its snapshot and SQL migration,

Then the snapshot is valid JSON, the migration creates the schema and prefixed table, and its types, defaults, index prefixes, unique identity predicate and nulls-distinct option match the resource declaration.

Owning case: `test/migration_generator_schema_snapshots_test.exs`, story tag `US-APMG-010`.

Status: source migrated; executable verification pending.
