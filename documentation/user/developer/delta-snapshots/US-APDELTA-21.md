# US-APDELTA-21 — AlterAttribute with unchanged references preserves the existing foreign key

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an attribute with a foreign key.
When an alteration omits unchanged reference data.
Then the existing foreign key remains in reduced state.

Owned by the case `AlterAttribute with unchanged references preserves the existing foreign key` in `test/snapshot_delta_test.exs`.
