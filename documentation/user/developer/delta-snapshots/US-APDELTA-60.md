# US-APDELTA-60 — reducer applies deltas in timestamp order regardless of write order

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given delta files written in a different order from their timestamps.
When the reader loads the directory.
Then operations apply in timestamp order.

Owned by the case `reducer applies deltas in timestamp order regardless of write order` in `test/snapshot_delta_test.exs`.
