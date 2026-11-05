# US-APDELTA-45 — Add same constraint twice raises conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an existing check constraint.
When a second add uses the same constraint.
Then the reducer rejects the duplicate.

Owned by the case `Add same constraint twice raises conflict` in `test/snapshot_delta_test.exs`.
