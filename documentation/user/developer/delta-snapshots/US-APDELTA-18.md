# US-APDELTA-18 — empty state + CreateTable + AddAttribute produces populated state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an empty reduced state.
When table and attribute creation operations are applied.
Then the resulting state contains the table and column.

Owned by the case `empty state + CreateTable + AddAttribute produces populated state` in `test/snapshot_delta_test.exs`.
