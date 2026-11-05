# US-APDELTA-37 — RenameAttribute where destination matches source (no-op rename) is allowed

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an existing attribute.
When a rename keeps the same source name.
Then the reducer accepts the no-op rename.

Owned by the case `RenameAttribute where destination matches source (no-op rename) is allowed` in `test/snapshot_delta_test.exs`.
