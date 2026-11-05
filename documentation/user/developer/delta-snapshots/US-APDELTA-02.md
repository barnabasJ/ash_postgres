# US-APDELTA-02 — temporal and citext unique-index fields survive the delta round-trip

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an index with temporal and citext metadata.
When its operation is encoded and decoded.
Then period exclusion SQL retains citext comparison and overlap semantics.

Owned by the case `temporal and citext unique-index fields survive the delta round-trip` in `test/snapshot_delta_test.exs`.
