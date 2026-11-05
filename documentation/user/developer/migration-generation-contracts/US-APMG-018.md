# US-APMG-018 — Constraint and column removal remains reversible

As a developer, I need removing a constrained column to generate reversible SQL in dependency order.

Given a persisted initial price column with its positive-price check constraint and an immutable next resource without that column,

When native generation compares the next resource with the stored snapshot,

Then the forward migration drops the constraint before removing price. The reverse migration recreates price before recreating its check constraint.

Owning case: `test/migration_generator_constraint_column_removal_test.exs`, story tag `US-APMG-018`.

Status: source migrated; executable verification pending.
