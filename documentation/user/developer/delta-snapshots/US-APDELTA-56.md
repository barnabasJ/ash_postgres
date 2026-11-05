# US-APDELTA-56 — CreateTable flips empty? to false even before any attribute ops

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an empty state before attributes are added.
When CreateTable is applied.
Then empty? becomes false.

Owned by the case `CreateTable flips empty? to false even before any attribute ops` in `test/snapshot_delta_test.exs`.
