# US-APMG-061 — Check constraint creation and replacement preserve exact SQL

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given a real resource with positive-price and escaped title constraints followed by an immutable changed price constraint,

When native generation processes both persisted resource versions,

Then the initial constraint SQL and escaping are preserved, and reverse replacement restores the original price check after dropping its replacement.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-061`.

Status: source migrated; executable verification pending.
