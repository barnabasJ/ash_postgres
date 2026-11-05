# US-APMG-062 — Check constraints account for the declared base filter

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given a real resource with an explicit base_filter_sql and price check,

When native generation writes its constraint migration,

Then the generated check includes the declared negated base-filter expression.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-062`.

Status: source migrated; executable verification pending.
