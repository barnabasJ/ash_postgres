# US-APDELTA-50 — CreateTable → DropTable → CreateTable can rebuild after a drop

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a dropped table.
When a later CreateTable rebuilds it.
Then the reduced state contains the new table state.

Owned by the case `CreateTable → DropTable → CreateTable can rebuild after a drop` in `test/snapshot_delta_test.exs`.
