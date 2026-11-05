# US-APDI-034 — delta files for a schema-prefixed resource land under {schema}.{table}/

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through schema-prefixed tables.

## Scenario

Given a static resource uses an explicit schema prefix.
When native delta generation writes and reduces its snapshot directory.
Then the schema-qualified directory and reduced table/schema/attributes remain correct.

Coverage: `US-APDI-034` in `test/delta_mode_schemas_test.exs`.
