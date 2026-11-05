# US-APDELTA-20 — RemoveAttribute on missing source is a conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an absent attribute source.
When RemoveAttribute targets it.
Then reduction fails instead of silently discarding the operation.

Owned by the case `RemoveAttribute on missing source is a conflict` in `test/snapshot_delta_test.exs`.
