# US-APMG-051 — Decimal changes preserve updated precision and scale

As a developer, I need decimal schema changes to retain their declared storage constraints.

Given a persisted price column with precision ten and scale two and an immutable next resource with precision twelve and scale four,

When native generation compares the next resource with the stored snapshot,

Then the second migration modifies price to decimal with precision twelve and scale four.

Owning case: `test/migration_generator_decimal_test.exs`, story tag `US-APMG-051`.

Status: source migrated; executable verification pending.
