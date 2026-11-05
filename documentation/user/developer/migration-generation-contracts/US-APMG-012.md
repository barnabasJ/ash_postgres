# US-APMG-012 — Custom indexes preserve nulls-distinct choices

As a developer, I need generated custom indexes to retain their PostgreSQL nulls-distinct setting.

Given a real resource with custom indexes using true, false and default nulls-distinct values,

When the generated index migration is read,

Then only the explicitly false index includes nulls_distinct false. The other index declarations remain intact.

Owning case: `test/migration_generator_null_distinct_indexes_test.exs`, story tag `US-APMG-012`.

Status: source migrated; executable verification pending.
