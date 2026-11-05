# US-APDELTA-46 — Remove non-existent constraint raises conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an absent check constraint.
When a removal targets it.
Then the reducer reports the missing constraint.

Owned by the case `Remove non-existent constraint raises conflict` in `test/snapshot_delta_test.exs`.
