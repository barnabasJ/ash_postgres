# US-APMG-050 — Decimal creation preserves declared precision and scale

As a developer, I need decimal schema changes to retain their declared storage constraints.

Given real decimal price, weight and rating fields with explicit, partial and absent constraints,

When native generation writes their initial table,

Then price retains precision ten and scale two, weight retains precision eight, and rating remains an unconstrained decimal.

Owning case: `test/migration_generator_decimal_test.exs`, story tag `US-APMG-050`.

Status: source migrated; executable verification pending.
