# US-APDELTA-10 — AddUniqueIndex with mixed atom/string keys round-trips

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a unique identity with atom and expression keys.
When its delta JSON is decoded.
Then each key keeps its original kind.

Owned by the case `AddUniqueIndex with mixed atom/string keys round-trips` in `test/snapshot_delta_test.exs`.
