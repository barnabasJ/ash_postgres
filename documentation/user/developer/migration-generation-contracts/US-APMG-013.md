# US-APMG-013 — Custom indexes preserve sort directions

As a developer, I need generated indexes to retain the ordering declared for each indexed field.

Given a real resource with a descending title index and a mixed id/descending-title index,

When native generation writes the index migration,

Then the actual generated SQL contains both named indexes with their original field order and descending direction.

Owning case: `test/migration_generator_index_sort_direction_test.exs`, story tag `US-APMG-013`.

Status: source migrated; executable verification pending.
