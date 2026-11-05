# US-APDELTA-41 — Remove non-existent identity raises conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an absent identity.
When a removal targets it.
Then the reducer rejects the missing identity.

Owned by the case `Remove non-existent identity raises conflict` in `test/snapshot_delta_test.exs`.
