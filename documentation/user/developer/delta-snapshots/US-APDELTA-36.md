# US-APDELTA-36 — AlterAttribute on missing source raises conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an absent attribute.
When AlterAttribute targets it.
Then reduction reports the missing-source conflict.

Owned by the case `AlterAttribute on missing source raises conflict` in `test/snapshot_delta_test.exs`.
