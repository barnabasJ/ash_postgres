# US-APMG-052 — Arbitrary decimal constraints omit precision and scale options

As a developer, I need decimal schema changes to retain their declared storage constraints.

Given a real required decimal field whose precision and scale are both arbitrary,

When native generation writes its initial table,

Then the field remains decimal with null false and the generated migration contains no precision or scale options.

Owning case: `test/migration_generator_decimal_test.exs`, story tag `US-APMG-052`.

Status: source migrated; executable verification pending.
