# US-APMG-053 — Decimal constraints can change from fixed to arbitrary

As a developer, I need decimal schema changes to retain their declared storage constraints.

Given a persisted price column with fixed precision/scale and an immutable next resource whose constraints are arbitrary,

When native generation writes the actual follow-up,

Then there are two migrations and the forward side modifies price to decimal without precision or scale options.

Owning case: `test/migration_generator_decimal_test.exs`, story tag `US-APMG-053`.

Status: source migrated; executable verification pending.
