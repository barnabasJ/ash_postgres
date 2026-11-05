# US-APMG-068 — Reverse constraint creation retains its base-filter composition

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given an actual initial filtered constraint and an immutable next resource without that constraint,

When native generation writes the follow-up and reverse SQL,

Then the reverse recreates the original check composed with its base filter.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-068`.

Status: source migrated; executable verification pending.
