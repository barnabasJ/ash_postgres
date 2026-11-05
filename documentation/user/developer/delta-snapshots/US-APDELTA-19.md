# US-APDELTA-19 — AddAttribute on existing source raises ConflictError

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an existing attribute source.
When another AddAttribute uses the same source.
Then reduction fails with the duplicate-source conflict.

Owned by the case `AddAttribute on existing source raises ConflictError` in `test/snapshot_delta_test.exs`.
