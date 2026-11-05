# US-APMG-046 — Supported literal defaults preserve exact migration values

As a developer, I need declared storage options to survive native migration generation.

Given a real resource with date, time, UTC and naive datetime, integer, float, Decimal, string, atom and boolean defaults,

When native generation writes the actual initial migration,

Then the original literal SQL fragments and full-precision Decimal string are retained for every asserted type.

Owning case: `test/migration_generator_default_values_test.exs`, story tag `US-APMG-046`.

Status: source migrated; executable verification pending.
