# US-APMG-067 — Conflicting same-name checks fail with an actionable error

As a developer, I need generated check constraints to preserve their authored SQL and reversible dependencies.

Given two real resources sharing one table and declaring different checks under the same has_body constraint name,

When native generation combines their declarations,

Then it raises the original contextual conflicting-check-constraints error instead of silently selecting a check.

Owning case: `test/migration_generator_check_constraints_test.exs`, story tag `US-APMG-067`.

Status: source migrated; executable verification pending.
